FROM ubuntu:latest

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8



RUN apt-get update && apt-get install -y samba && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /srv/samba/shared && chmod -R 0777 /srv/samba/shared



COPY smb.conf /etc/samba/smb.conf


EXPOSE 137/udp 138/udp 139/tcp 445/tcp


CMD ["smbd", "-F", "--no-process-group"]

