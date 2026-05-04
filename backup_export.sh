#!/bin/bash

CONTAINER="<CONTAINER_NAME_OR_ID>"
BACKUP_DIR="<BACKUP_DIRECTORY_PATH>"
TMP_DIR="/tmp/paperless_backup_tmp"
LOGFILE="$BACKUP_DIR/docker_backup.log"

DATE=$(date +"%d.%m.%Y %H:%M:%S")
STAMP=$(date +"%d-%m-%Y_%H-%M-%S")

mkdir -p "$BACKUP_DIR"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

LOG_BLOCK=""

# Funktion zum Loggen (sammelt Text)
log() {
    LOG_BLOCK+="$1\n"
}

log "Backup gestartet am $DATE"

# 1. Working Dir holen
WORKDIR=$(docker exec "$CONTAINER" pwd 2>/dev/null)
if [ -z "$WORKDIR" ]; then
    log "FEHLER: Container nicht erreichbar"
    write_log
    exit 1
fi

EXPORT_PATH=$(dirname "$WORKDIR")/export

# 2. Export erzeugen
OUTPUT=$(docker exec "$CONTAINER" document_exporter ../export 2>&1)
if [ $? -ne 0 ]; then
    log "FEHLER beim Export:"
    log "$OUTPUT"
    write_log
    exit 1
fi

# 3. Export temporär kopieren
if ! docker cp "$CONTAINER:$EXPORT_PATH" "$TMP_DIR/" 2>>"$LOGFILE"; then
    log "FEHLER beim Kopieren"
    write_log
    exit 1
fi

# 4. Hash berechnen
NEW_HASH=$(tar -cf - -C "$TMP_DIR/export" . | sha256sum | awk '{print $1}')
LAST_HASH_FILE="$BACKUP_DIR/last.hash"

OLD_HASH=""
[ -f "$LAST_HASH_FILE" ] && OLD_HASH=$(cat "$LAST_HASH_FILE")

# 5. Vergleich
if [ "$NEW_HASH" == "$OLD_HASH" ]; then
    log "Keine Änderung – kein neues Backup"
    rm -rf "$TMP_DIR"
    write_log
    exit 0
fi

# 6. Neues Backup speichern
BACKUP_PATH="$BACKUP_DIR/export_$STAMP"
mv "$TMP_DIR/export" "$BACKUP_PATH"
echo "$NEW_HASH" > "$LAST_HASH_FILE"

log "Neues Backup erstellt: $BACKUP_PATH"

# 7. Alte Backups löschen (nur 3 behalten)
ls -dt "$BACKUP_DIR"/export_* 2>/dev/null | tail -n +4 | xargs -r rm -rf

# 8. Container leeren
docker exec "$CONTAINER" sh -c "rm -rf ${EXPORT_PATH:?}/*"

log "Backup erfolgreich beendet am $(date +"%d.%m.%Y %H:%M:%S")"

# 9. Log nach oben schreiben (prepend)
write_log() {
    TMP_LOG=$(mktemp)
    chmod 644 "$TMP_LOG"

    {
        echo ""
        printf "%b" "$LOG_BLOCK"
    } > "$TMP_LOG"

    cat "$LOGFILE" >> "$TMP_LOG" 2>/dev/null
    mv "$TMP_LOG" "$LOGFILE"
}

# Log schreiben
write_log
