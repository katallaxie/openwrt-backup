#!/bin/sh

# !Should be run as root

# Variables
CONFIG_FOLDER=/etc
BACKUP_FOLDER=/root/backup
HOSTNAME=`uci get system.@system[0].hostname`
RSYNC_TARGET=''
RSYNC_USER=''
RSYNC_PASS=''

# Create /root/backup
mkdir -p ${BACKUP_FOLDER}

# Remove all old backups
rm ${BACKUP_FOLDER}/*.gz

# Backup installed package list to /etc
opkg list-installed | cut -f 1 -d ' ' > /etc/packages.txt

# Backup /etc
tar -czf ${BACKUP_FOLDER}/${HOSTNAME}_$(date +%Y%m%d_%H%M)_etc.tar.gz ${CONFIG_FOLDER} >/dev/null 2>&1

# Rsync (e.g. Synology)
rsync -avzhe 'ssh -p ${RSYNC_PASS}' --progress ${BACKUP_FOLDER} ${RSYNC_USER}@{RSYNC_HOST}:${RSYNC_TARGET}

exit;
