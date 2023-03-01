#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/binexport
DISPLAY=:0.0
x=$(systemctl show --property MainPID confluence.service | cut -c 9-13)
y=$(lsof -p $x | wc -l)
if [ $y -gt 12000 ]; then
    echo "too many open file ${y} on $(date)" >>/home/centos/log-opefile/output-issue.log
    aws ses send-email --from Atlassian@ss.com --destination file:///home/centos/ses/destination.json --message file:///home/centos/ses/message.json
else
    echo "everything is fine and the open file number is ${y} on $(date)" >>/home/centos/log-opefile/output.log
fi
