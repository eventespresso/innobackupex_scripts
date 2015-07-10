#!/bin/bash
# Script to do full backup of database using innobackupex and copy for incremental script after.
# This script should only be set on a cron to run daily.
# Note database creds will need replaced with your own.

DBUSER = 'root'
DBPASS = 'yer_secure_password'
SCRIPTSBASEDIR = 'path/to/scripts'

# log start
echo "Started full backup" 1>&2;

# pre backup
sudo chown -R mysql: /var/lib/mysql
sudo find /var/lib/mysql -type d -exec chmod 770 "{}" \;

# delete existing full and incr-base backup
rm -rf /data/backups/full
rm -rf /data/backups/incr-base
rm ${SCRIPTSBASEDIR}/hourlyref.dat

# innobackupex create initial backup
innobackupex --user=${DBUSER} --password=${DBPASS} --no-timestamp --rsync /data/backups/full

# before preparing copy to incremental backup base
mkdir /data/backups/incr-base
cp -r /data/backups/full/* /data/backups/incr-base/

# Set the lastsnvalue
lastlsn=`grep last_lsn /data/backups/full/xtrabackup_checkpoints | awk '{ print $3 }'`
echo "The lastlsn value is $lastlsn" 1>&2
#save lsn to dat
echo $lastlsn > ${SCRIPTSBASEDIR}/hourlyref.dat

# now do prepare on full
innobackupex --apply-log /data/backups/full

# apply redo log on incr-base
innobackupex --apply-log --redo-only /data/backups/incr-base

# log end
echo "Ended full backup" 1>&2;
