#  Papperless-ngx Portainer Stacks Backup - Restore

##### Datenbank Sichern
- <CONTAINER_ID> Suchen
```
docker ps # <--- Alte <CONTAINER_ID>
CONTAINER ID   IMAGE                                        COMMAND  CREATED        STATUS                  PORTS                     NAMES
2ed3ll5a68c3   ghcr.io/paperless-ngx/paperless-ngx:latest   "/init"  46 hours ago   Up 46 hours (healthy)   0.0.0.0:8010->8000/tcp    Paperless-ngx
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
CONTAINER ID   IMAGE                                        COMMAND  CREATED        STATUS                  PORTS                     NAMES
7ad6nn2a92l7   ghcr.io/paperless-ngx/paperless-ngx:latest   "/init"  1 hours ago   Up 1 hours (healthy)   0.0.0.0:8020->8000/tcp    Paperless-ngx

docker exec -it <CONTAINER_ID> document_importer ../export
```
