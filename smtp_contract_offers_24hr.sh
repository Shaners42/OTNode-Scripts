#!/bin/bash

#This script checks for OT-Node accepted offers within the last 24 hours
#and sends an email using CURL to SendGrid's SMTP API. 
#It runs outside Docker and looks at Docker logs (Container ID is statically set)
#Disclaimer: I'm not a developer and everything here is very badly coded. It's just here so I can keep track. 

awk -v d="$(date -d'1 hour ago' +'{"log":"%Y-%m-%dT%k:%M:%S')" '$1" "$2>=d &&/ve been chosen for offer/' /var/lib/docker/containers/516*/516*-json.log > /home/output1hr.txt

strCountOffers="Number of offers in the last hour: "
intCountOffers=$(cat /home/output1hr.txt | wc -l)
strFullOffers=$strCountOffers$intCountOffers


function sendOffersSMTP {
        curl -i --request POST \
                --url https://api.sendgrid.com/v3/mail/send \
                --header 'Authorization: Bearer <API Key>' \
                --header 'Content-Type: application/json' \
                --data '{"personalizations": [{"to": [{"email": "<email address>"}]}],"from": {"email": "OTNode01@otnode01.ie"},"subject": 
"OT Node Offers Hourly" ,"content": [{"type": "text/plain", "value": "'"$strFullOffers"'"}]}'
}

if [[ $intCountOffers != 0 ]]
then
        sendOffersSMTP
fi
