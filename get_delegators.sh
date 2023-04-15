#!/bin/sh
touch /tmp/delegator_list.txt
touch /tmp/delegator_stakes.txt
touch /tmp/delegators.txt

NEXT_CURSOR="nothing"

echo $NEXT_CURSOR
while [ ! $NEXT_CURSOR = null ]
do
    if [ $NEXT_CURSOR = "nothing"  ]
    then
        curl -X 'POST' 'https://mainnet.radixdlt.com/validator/stakes' -H 'Content-Type: application/json' -H 'X-Radixdlt-Target-Gw-Api: 1.0' -d '{
                "network_identifier": {
                "network": "mainnet"
                },
                "validator_identifier": {
                "address": "<<VALIDATOR ADDRESS>>"
                },
                "limit": "30"
                }' | jq ".account_stake_delegations[].account.address" >> /tmp/delegator_list.txt;
                curl -X 'POST' 'https://mainnet.radixdlt.com/validator/stakes' -H 'Content-Type: application/json' -H 'X-Radixdlt-Target-Gw-Api: 1.0' -d '{
                "network_identifier": {
                "network": "mainnet"
                },
                "validator_identifier": {
                "address": "<<VALIDATOR ADDRESS>>"
                },
                "limit": "30"
                }' | jq ".account_stake_delegations[].total_stake.value" >> /tmp/delegator_stakes.txt;

        NEXT_CURSOR=$(curl -X 'POST' 'https://mainnet.radixdlt.com/validator/stakes' -H 'Content-Type: application/json' -H 'X-Radixdlt-Target-Gw-Api: 1.0' -d '{
                "network_identifier": {
                "network": "mainnet"
                },
                "validator_identifier": {
                "address": "<<VALIDATOR ADDRESS>>"
                },
                "limit": "30"
                }' | jq .next_cursor);
                echo $NEXT_CURSOR
    else
        curl -X 'POST' 'https://mainnet.radixdlt.com/validator/stakes' -H 'Content-Type: application/json' -H 'X-Radixdlt-Target-Gw-Api: 1.0' -d '{
        "network_identifier": {
         "network": "mainnet"
        },
        "validator_identifier": {
        "address": "<<VALIDATOR ADDRESS>>"
        },
        "limit": "30",
        "cursor": '"$NEXT_CURSOR"'
        }' | jq ".account_stake_delegations[].account.address" >> /tmp/delegator_list.txt;
        curl -X 'POST' 'https://mainnet.radixdlt.com/validator/stakes' -H 'Content-Type: application/json' -H 'X-Radixdlt-Target-Gw-Api: 1.0' -d '{
        "network_identifier": {
         "network": "mainnet"
        },
        "validator_identifier": {
        "address": "<<VALIDATOR ADDRESS>>"
        },
        "limit": "30",
        "cursor": '"$NEXT_CURSOR"'
        }' | jq ".account_stake_delegations[].total_stake.value" >> /tmp/delegator_stakes.txt;

        NEXT_CURSOR=$(curl -X 'POST' 'https://mainnet.radixdlt.com/validator/stakes' -H 'Content-Type: application/json' -H 'X-Radixdlt-Target-Gw-Api: 1.0' -d '{
                "network_identifier": {
                "network": "mainnet"
                },
                "validator_identifier": {
                "address": "<<VALIDATOR ADDRESS>>"
                },
                "limit": "30",
                "cursor": '"$NEXT_CURSOR"'
                }' | jq .next_cursor);
    fi
done
paste -d "," /tmp/delegator_list.txt /tmp/delegator_stakes.txt > /tmp/delegators.txt
cp /tmp/delegators.txt ~/delegators_$(date +%Y%m%d_%H%M).csv
rm /tmp/delegator_list.txt
rm /tmp/delegator_stakes.txt
rm /tmp/delegators.txt
