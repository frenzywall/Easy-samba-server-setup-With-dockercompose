FROM ubuntu:20.04


RUN apt-get update && apt-get install -y samba && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /srv/samba/shared && chmod 0777 /srv/samba/shared


COPY smb.conf /etc/samba/smb.conf

COPY allow_samba_thru_firewall.sh /usr/local/bin/allow_samba_thru_firewall.sh

RUN chmod +rwx /usr/local/bin/allow_samba_thru_firewall.sh

EXPOSE 137/udp 138/udp 139/tcp 445/tcp


CMD ["/bin/bash", "-c", "/usr/local/bin/allow_samba_thru_firewall.sh && smbd -F --no-process-group"]
