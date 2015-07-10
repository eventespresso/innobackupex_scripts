#!/bin/bash
# Very simple script for prepending the date on each line in the log.
while read line ; do
	echo " $(date): ${line}"
done
