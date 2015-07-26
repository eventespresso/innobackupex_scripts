#!/bin/bash
# this command runs the backup hourly script and pipes all stderr to a log file prepended with a timestamp.
# BASEDIR = the directory to the script on your site.  The full path needs to be used if you want to run this with cron.
BASEDIR='/some/path/to/scripts';
( ($BASEDIR/main_scripts/backuphourlymain.sh) 3>&1 1>&2- 2>&3- ) | $BASEDIR/predate.sh >>/var/log/esbackups/backuphourly.log
