FROM filebrowser/filebrowser AS file-server

LABEL maintainer="James (github.com/JamesWRC)"

FROM tiredofit/db-backup AS db-backup

COPY --from=file-server /healthcheck.sh ./healthcheck.sh
COPY --from=file-server /filebrowser ./filebrowser

ENV FB_ADDRESS=0.0.0.0
ENV DB_DUMP_TARGET=/srv/db_backup
EXPOSE 80
# Volumes: 
#   - 'db_backup' is a local directory to store backups
#   - 'backup' is a container directory to store backups
# This is stored in Railway.app template

# Start filebrowser (file-server)
ENTRYPOINT [ "/filebrowser" ] 