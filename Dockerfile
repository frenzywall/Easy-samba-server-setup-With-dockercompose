FROM ubuntu:20.04


RUN apt-get update && apt-get install -y samba && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /srv/samba/shared && sudo chmod -R 0777 /srv/samba/shared



COPY smb.conf /etc/samba/smb.conf


EXPOSE 137/udp 138/udp 139/tcp 445/tcp


CMD ["smbd", "-F", "--no-process-group"]

