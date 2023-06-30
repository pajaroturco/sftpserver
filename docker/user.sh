#!/bin/bash
set -e
 
printf "\n\033[0;44m---> Creating SSH admin user.\033[0m\n"
 
useradd -m -d /home/admin -G ssh admin -s /bin/bash
echo "admin:admin" | chpasswd
echo 'PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin"' >> /home/admin/.profile
 
echo "admin ALL=NOPASSWD:/bin/rm" >> /etc/sudoers
echo "admin ALL=NOPASSWD:/bin/mkdir" >> /etc/sudoers
echo "admin ALL=NOPASSWD:/bin/chown" >> /etc/sudoers
echo "admin ALL=NOPASSWD:/usr/sbin/useradd" >> /etc/sudoers
echo "admin ALL=NOPASSWD:/usr/sbin/deluser" >> /etc/sudoers
echo "admin ALL=NOPASSWD:/usr/sbin/chpasswd" >> /etc/sudoers

printf "\n\033[0;44m---> Creating SSH user.\033[0m\n"

addgroup sftp

mkdir -p /uploads/${SSH_MASTER_USER}/files/upload
mkdir /uploads/${SSH_MASTER_USER}/.ssh
touch /uploads/${SSH_MASTER_USER}/.ssh/authorized_keys

useradd -d /uploads/${SSH_MASTER_USER} -G sftp ${SSH_MASTER_USER} -s /usr/sbin/nologin

echo "${SSH_MASTER_USER}:${SSH_MASTER_PASS}" | chpasswd

chown ${SSH_MASTER_USER}:${SSH_MASTER_USER} -R /uploads/${SSH_MASTER_USER}/files/upload
chown ${SSH_MASTER_USER}:sftp -R /uploads/${SSH_MASTER_USER}/.ssh
chown ${SSH_MASTER_USER}:${SSH_MASTER_USER} /uploads/${SSH_MASTER_USER}/.ssh/authorized_keys

chmod 700 /uploads/${SSH_MASTER_USER}/.ssh
chmod 600 /uploads/${SSH_MASTER_USER}/.ssh/authorized_keys

exec "$@" 
