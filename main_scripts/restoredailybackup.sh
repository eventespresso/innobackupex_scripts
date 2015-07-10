#!/bin/sh
#script to restore from daily incremental backup

# stop mysql service, make temp directory for current mysql and move to it.
service mysql stop
rm -rf /tmp/mysqlbackup
mkdir /tmp/mysqlbackup
mv /var/lib/mysql/* /tmp/mysqlbackup/

# Restore from backup
innobackupex --copy-back /data/backups/full

# make sure permissions are set properly
chown -R mysql: /var/lib/mysql

# Delete temp-restore directory and restart mysql
service mysql start
echo "Don't forget to stop slaves and ensure they have the new db added"
