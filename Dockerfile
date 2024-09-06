
FROM ubuntu:20.04


RUN apt-get update \
    && apt-get install -y samba \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /srv/samba/shared


RUN chmod 0777 /srv/samba/shared


COPY smb.conf /etc/samba/smb.conf

COPY User-scripts(host) /usr/local/bin/user-scripts

RUN chmod +x /usr/local/bin/User_scripts(hosts)/Run_from_here.sh

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

CMD ["/bin/bash", "smbd", "-F", "--no-process-group"]