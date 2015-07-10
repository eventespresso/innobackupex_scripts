#!/bin/sh
#script to restore from hourly incremental backup

# stop mysql service, make temp directory for current mysql and move to it.
service mysql stop
rm -rf /tmp/mysqlbackup
mkdir /tmp/mysqlbackup
mv /var/lib/mysql/* /tmp/mysqlbackup/

# Copy inc-base contents to temporary directory for restoring from so we can leave the incr-backups on the cron.
rm -rf /data/backups/temp-restore
mkdir /data/backups/temp-restore
cp -r /data/backups/incr-base/* /data/backups/temp-restore/

# Finish applying logs
innobackupex --apply-log /data/backups/temp-restore

# Restore from backup
innobackupex --copy-back /data/backups/temp-restore

# make sure permissions are set properly
chown -R mysql: /var/lib/mysql

service mysql start
echo "Don't forget to stop slaves and ensure they have the new db added"
