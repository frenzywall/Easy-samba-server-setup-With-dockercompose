FROM ubuntu:20.04

# Install Samba and clean up unnecessary files
RUN apt-get update && apt-get install -y samba && rm -rf /var/lib/apt/lists/*

# Create shared folder inside the container and set permissions
RUN mkdir -p /srv/samba/shared && chmod 0777 /srv/samba/shared

# Copy your custom Samba configuration file into the container
COPY smb.conf /etc/samba/smb.conf

# Expose necessary Samba ports
EXPOSE 137/udp 138/udp 139/tcp 445/tcp

# Start Samba service in the foreground
CMD ["smbd", "-F", "--no-process-group"]

