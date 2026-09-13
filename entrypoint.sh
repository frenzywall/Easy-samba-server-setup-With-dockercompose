#!/bin/sh
set -e

# Configuration defaults
SHARE_NAME="${SAMBA_SHARE_NAME:-Shared}"
USER_NAME="${SAMBA_USER:-sambauser}"
PASSWORD="${SAMBA_PASSWORD:-samba123}"
READ_ONLY="${SAMBA_READ_ONLY:-no}"
GUEST_OK="${SAMBA_GUEST_OK:-yes}"
PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

# 1. User & Group Management (PUID / PGID pattern)
if ! getent group "$PGID" >/dev/null 2>&1; then
    addgroup -g "$PGID" sambagroup
    GROUP_NAME="sambagroup"
else
    GROUP_NAME=$(getent group "$PGID" | cut -d: -f1)
fi

if ! getent passwd "$PUID" >/dev/null 2>&1; then
    adduser -u "$PUID" -G "$GROUP_NAME" -D -H -s /sbin/nologin "$USER_NAME"
else
    EXISTING_USER=$(getent passwd "$PUID" | cut -d: -f1)
    if [ "$EXISTING_USER" != "$USER_NAME" ]; then
        USER_NAME="$EXISTING_USER"
    fi
fi

# 2. Configure Samba Password
if [ -n "$PASSWORD" ]; then
    printf "%s\n%s\n" "$PASSWORD" "$PASSWORD" | smbpasswd -s -a "$USER_NAME" >/dev/null 2>&1
    smbpasswd -e "$USER_NAME" >/dev/null 2>&1
fi

# 3. Dynamic smb.conf share adjustments
if [ -n "$SHARE_NAME" ] && [ "$SHARE_NAME" != "Shared" ]; then
    sed -i "s/\[Shared\]/\[$SHARE_NAME\]/g" /etc/samba/smb.conf
fi

if [ "$READ_ONLY" = "yes" ]; then
    sed -i "s/read only = no/read only = yes/g" /etc/samba/smb.conf
    sed -i "s/writable = yes/writable = no/g" /etc/samba/smb.conf
fi

if [ "$GUEST_OK" = "no" ]; then
    sed -i "s/guest ok = yes/guest ok = no/g" /etc/samba/smb.conf
fi

# 4. Storage directory setup
mkdir -p /srv/samba/shared
chown -R "$PUID:$PGID" /srv/samba/shared 2>/dev/null || true
chmod 0777 /srv/samba/shared

# 5. Output professional startup banner to container logs
cat <<EOF
======================================================================
  ðŸš€ Easy Samba Server (Professional Grade)
======================================================================
  Share Name     : ${SHARE_NAME}
  User Account   : ${USER_NAME}
  Guest Access   : $([ "$GUEST_OK" = "yes" ] && echo "Enabled" || echo "Disabled")
  Read Only      : $([ "$READ_ONLY" = "yes" ] && echo "Yes" || echo "No")
  UID / GID      : ${PUID}:${PGID}
  Protocols      : SMB2 & SMB3 (SMB1 disabled for security)
  macOS VFS      : Apple Fruit + Catia + Streams_Xattr (Active)
----------------------------------------------------------------------
  Ready for connections!
  Windows Explorer   : \\\\<YOUR_HOST_IP>\\${SHARE_NAME}
  macOS Finder       : smb://<YOUR_HOST_IP>/${SHARE_NAME}
  Linux / Mobile     : smb://<YOUR_HOST_IP>/${SHARE_NAME}
======================================================================
EOF

exec "$@"
