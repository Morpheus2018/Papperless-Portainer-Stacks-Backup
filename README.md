# Papperless-Portainer-Stacks-Backup

##### <CONTAINER_ID> Suchen
```
docker ps # <--- Alte <CONTAINER_ID>
```
##### [backup_export.sh](https://github.com/Morpheus2018/Papperless-Portainer-Stacks-Backup/blob/main/backup_export.sh#L3#L4)
[CONTAINER="<CONTAINER_ID>"](https://github.com/Morpheus2018/Papperless-Portainer-Stacks-Backup/blob/main/backup_export.sh#L3)

[BACKUP_DIR="<BACKUP_DIRECTORY_PATH>"](https://github.com/Morpheus2018/Papperless-Portainer-Stacks-Backup/blob/main/backup_export.sh#L4)
```
nano /usr/local/bin/backup_export.sh
chmod +x /usr/local/bin/backup_export.sh
/usr/local/bin/backup_export.sh
```
##### Datenbank wiederherstellen
- Kopiere den Inhalt von <BACKUP_DIRECTORY_PATH> in den 'export' Ordner der neuen Installation Paperless.
```
docker ps # <--- Neue <CONTAINER_ID>
docker exec -it <CONTAINER_ID> document_importer ../export
```
