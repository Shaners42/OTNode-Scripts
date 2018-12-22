#!/bin/bash

#This script moves OT-Node log files older than 24 hours to an archive folder
#Runs within Docker container
#Disclaimer: I'm not a developer and everything here is very badly coded. It's just here so I can keep track.

function SMTP_ArchivedLogs {
        curl -i --request POST \
                --url https://api.sendgrid.com/v3/mail/send \
                --header 'Authorization: Bearer <API Key>' \
                --header 'Content-Type: application/json' \
                --data '{"personalizations": [{"to": [{"email": "<email adddress>"}]}],"from": {"email": "OTNode01@OTNode01.ie"},"subject":"OT Node Logs Archived" ,"content": [{"type": "text/plain", "value": "OT Node logs older than 24 hours archived"}]}'
}

find /ot-node/logs/*.log  -type f -mtime +0 -print | xargs -I {} mv "{}" /ot-node/logs/archived-logs
SMTP_ArchivedLogs
