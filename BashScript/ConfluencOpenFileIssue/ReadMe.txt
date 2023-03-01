This script for catching open file of specific processes. In this case was Confluence common issue of 7.19.0 release 
which is open too many file on the machine and we had to catch this before it hit the hard limit of Ulimit of the machine.

Prerequisite:

1. Enable SES service on AWS.
2. Increase the Ulimit for the process to 20000

Then you need to adjust the reciver mail in destination.json and the location of both files (destination.json, message.json)
need to be added in fetch-openfile.sh

The idea is to get notified and restart the confluence service. It was temporary solution because we are migrating to cloud.