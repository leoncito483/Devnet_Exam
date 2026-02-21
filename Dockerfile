FROM ubuntu:22.04
RUN apt-get update && apt-get install -y vsftpd
RUN useradd -m -s /bin/bash admin && echo "admin:admin" | chpasswd
RUN mkdir -p /home/admin/backups && chown admin:admin /home/admin/backups
RUN echo "anonymous_enable=NO" > /etc/vsftpd.conf
RUN echo "local_enable=YES" >> /etc/vsftpd.conf
RUN echo "write_enable=YES" >> /etc/vsftpd.conf
EXPOSE 21
CMD service vsftpd start && tail -f /dev/null
