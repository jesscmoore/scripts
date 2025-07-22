#!/bin/bash
#
# Time-stamp: <Friday 2023-09-28 10:42:12 +1000 Jess Moore>
#
# A supplied first argument will override the HOST_NAME from
# linode.json.
#
# Adapted from similar script by Graham Williams.

cd $HOME/Documents/scripts
. ./common.sh

if [ -n "$1" ]; then
    HOST_NAME=$1
fi

########################################################################
# CADDY Server Test
########################################################################

# testURL https://${HOST_NAME} 'Server Deployed|<html>'


########################################################################
if [ "${LIN_ACCT}" = "jmanutce" ]; then
########################################################################

	DASH="_dash-loading"
	WEB="<html>"
	DEPLOYED="Server Deployed"

	QUERY="https://${HOST_NAME}"
	CMD=$(curl --silent ${QUERY})

    # BZTE SERVER RETURNS A HTML PAGE OF THE DASH VISUALISATION
	# CHECK EGREP ON RETURNED PAGE RETURNS THE MATCHED HTML TAG

	RESPONSE=$(echo ${CMD} | egrep ${DASH})
    NUM=$(echo ${RESPONSE} | wc -l)
    EXP=1

    if [ ${NUM} -eq ${EXP} ]; then
	printf "${QUERY} returned dashboard.\n"
	/usr/bin/osascript -e 'tell app "System Events" to display dialog "caddy returned dashboard"'
    else
	printf "FAIL: ${API}/${QUERY} did NOT return the expected number of lines.\n"
	printf "===================================\n"
	printf "EXPECTED TO BE ${EXP} LINES BUT GOT ${NUM}.\n"
	printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	printf "OBTAINED\n"
	printf "${RESPONSE}"
	/usr/bin/osascript -e 'tell app "System Events" to display dialog "curl didnt return dashboard\ncaddy failed\n DO systemctl stop caddy\n THEN enable, start, reload, status"'
	printf "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
    fi

	RESPONSE=$(echo ${CMD} | egrep ${WEB})
    NUM=$(echo ${RESPONSE} | wc -l)
    EXP=1

    if [ ${NUM} -eq ${EXP} ]; then
	printf "${QUERY} returned website.\n"
	/usr/bin/osascript -e 'tell app "System Events" to display dialog "caddy returned website"'
    else
	printf "FAIL: ${API}/${QUERY} did NOT return the expected number of lines.\n"
	printf "===================================\n"
	printf "EXPECTED TO BE ${EXP} LINES BUT GOT ${NUM}.\n"
	printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	printf "OBTAINED\n"
	printf "${RESPONSE}"
	/usr/bin/osascript -e 'tell app "System Events" to display dialog "curl didnt return website\ncaddy failed\n DO systemctl stop caddy\n THEN enable, start, reload, status"'
	printf "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
    fi

fi

exit
