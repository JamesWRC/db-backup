FROM filebrowser/filebrowser AS file-server

LABEL maintainer="James (github.com/JamesWRC)"

FROM tiredofit/db-backup AS db-backup

COPY --from=file-server /healthcheck.sh ./healthcheck.sh
COPY --from=file-server /filebrowser ./filebrowser

ENV FB_ADDRESS=0.0.0.0
ENV FB_PORT=80

# FB_USERNAME ARG for setting admin username on build
# Use deafult username of 'admin' if not set at build time. NOT SECURE. CHANGE ASAP IN SETTINGS!
ARG FB_USERNAME=admin 
ENV FB_USERNAME=$FB_USERNAME

# FB_PASSWORD ARG for setting admin password on build
# Use default password of 'password'. NOT SECURE. CHANGE ACCOUNT ASAP IN SETTINGS!
ARG FB_PASSWORD=password
ENV FB_PASSWORD=$FB_PASSWORD

# Used got telling db-backup whoch volume to dump to.
ENV DB_DUMP_TARGET=/srv/db_backup
EXPOSE 80:80

WORKDIR /srv/

# Volumes: 
#   - 'db_backup' is a local directory to store backups
#   - 'backup' is a container directory to store backups
# This is stored in Railway.app template

# Start filebrowser (file-server)
ENTRYPOINT [ "/filebrowser" ] 