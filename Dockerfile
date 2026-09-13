FROM alpine:latest

# Install Samba, user management utilities, tini (init signal handler), and dos2unix
RUN apk add --no-cache samba shadow tini dos2unix

# Prepare shared directory
RUN mkdir -p /srv/samba/shared && \
    chmod -R 0777 /srv/samba/shared

# Copy configuration and entrypoint
COPY smb.conf /etc/samba/smb.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN dos2unix /usr/local/bin/entrypoint.sh /etc/samba/smb.conf && \
    chmod +x /usr/local/bin/entrypoint.sh

# SMB Ports:
# 445: Direct SMB (SMB2/SMB3 - Primary modern port)
# 139: SMB over NetBIOS
EXPOSE 445 139

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD smbcontrol smbd ping || exit 1

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["smbd", "-F", "--no-process-group"]
