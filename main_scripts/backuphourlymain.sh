#!/bin/bash
# Script to do incremental backup of database to be called on cron hourly
# Note database creds will need replaced with your own.

DBUSER='root'
DBPASS='yer_secure_password'
SCRIPTSBASEDIR='path/to/scripts'


echo "Starting hourly backup" 1>&2;

#get cached lastlsn
lastlsn=`cat ${SCRIPTSBASEDIR}/hourlyref.dat`

echo "The last lsn value is: $lastlsn" 1>&2;

# Take incremental backup

innobackupex --user=${DBUSER} --password=${DBPASS} --no-timestamp --incremental --rsync /data/backups/inc --incremental-lsn=$lastlsn

#get new lastlsn value and cache for next run
lastlsn=`grep last_lsn /data/backups/inc/xtrabackup_checkpoints | awk '{ print $3 }'`
echo $lastlsn > ${SCRIPTSBASEDIR}/hourlyref.dat

# Apply incremental changes and redo log
innobackupex --apply-log --redo-only  /data/backups/incr-base --incremental-dir=/data/backups/inc

# Remove incremental dir for clean start on next run

rm -rf /data/backups/inc
echo "Ended hourly backup" 1>&2;
