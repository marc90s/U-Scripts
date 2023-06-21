#!/bin/bash
export PATH=/sbin:/bin:/usr/sbin:/usr/bin

LOGS=/mnt/current_log_storage/system_logs/
COMPRESS_LOGS=/mnt/retained_log_storage
DATE=$(date +"%m-%d-%Y")

tar -czf ${COMPRESS_LOGS}/old-logs-${DATE}.tar ${LOGS} --remove-files

if [ $? -eq 0 ] ; then
        find ${COMPRESS_LOGS} -type f -mtime +7 -name "*.tar" -exec rm -rf {} +
else
 exit

fi
