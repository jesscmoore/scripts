#!/bin/bash
#
# Time-stamp: <Friday 2023-06-19 19:22:02 Jess Moore>
#
# Call python nc_msg.py with environment variables to send message
#
# Usage: bash nc_msg.sh "My message" chat_id


MSG=$1
ROOM=$2
source ~/.Renviron

# python3.11 ~/Documents/scripts/nc_msg.py "${MSG}" ${ROOM}

curl -u ${NC_USERNAME}:${NC_PASSWORD} "https://cloud.ecosysl.net/ocs/v2.php/apps/spreed/api/v1/chat/${ROOM}" -H "Content-Type: application/json" -H "Accept: application/json" -H 'cache-control: no-cache' -H "OCS-APIRequest: true" --data-raw "{\"message\":\"$MSG\"}"

