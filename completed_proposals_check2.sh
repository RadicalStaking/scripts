#!/bin/bash

while true
do
	curl -u admin:$NGINX_ADMIN_PASSWORD -k -X POST 'https://localhost/entity' --header 'Content-Type: application/json' --data-raw '{
    "network_identifier": {
        "network": "mainnet"
    },
    "entity_identifier": {
        "address": "<<VALIDATOR ADDRESS>>",
        "sub_entity": {
            "address": "system"
         }
    }
}' | jq | grep proposals_completed
   date
   echo ----
   sleep 1
done
