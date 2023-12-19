#!/bin/bash

# backup.sh

# Definovanie názvu zálohy
BACKUP_NAME="server_backup_$(date +%Y%m%d).tar.gz"


# Na zistenie verzie CentOS na vašom systéme môžete použiť jeden z nasledujúcich príkazov v termináli:

cat /etc/centos-release
hostnamectl
# rpm -q centos-release

# zistenie baličkov v OS abz si si ich pridal do Dockerfile

rpm -qa
yum list installed
dnf list installed





# yastav Http server

httpd -v

systemctl stop httpd

# PHP
php -v



# Yisti ver DB
psql -V
# alebo 
postgres -V

# yaloha DB

pg_dump -U [username] databasename > backupfile.sql
pg_dump -U [username] databasename | gzip > backupfile.sql.gz
pg_dumpall -U [username] > backupfile.sql

# Zastavenie PostgreSQL
systemctl stop postgresql

# Kontrola, či je PostgreSQL zastavené
if systemctl is-active --quiet postgresql; then
    echo "PostgreSQL sa nepodarilo zastaviť. Zálohovanie zrušené."
    exit 1
fi

# Vylúčenie nežiaducich cest a súborov
EXCLUDES="--exclude=/dev/* --exclude=/proc/* --exclude=/sys/* --exclude=/tmp/* --exclude=/run/* --exclude=/mnt/* --exclude=/media/* --exclude=/lost+found"

# Vytvorenie tar archívu
tar cvpzf ./$BACKUP_NAME / $EXCLUDES

# Reštartovanie PostgreSQL
systemctl start postgresql

# Kontrola, či je PostgreSQL spustené
if ! systemctl is-active --quiet postgresql; then
    echo "PostgreSQL sa nepodarilo spustiť."
fi
