#!/bin/bash
#
# Time-stamp: <Friday 2023-04-28 09:12:41 +1000 Graham Williams>
#
# A supplied first argument will override the HOST_NAME from
# linode.json.

. ./common.sh

if [ -n "$1" ]; then
    HOST_NAME=$1
fi

########################################################################
# CADDY Server Setup
########################################################################

# testURL https://${HOST_NAME} 'Server Deployed|<html>'

########################################################################
if [ "${LIN_ACCT}" = "gjwanufais" ]; then
########################################################################

    API="https://${SUBDOMAIN}.${HOST_NAME}"
    
    # FAIS DATA ENGINE API SETUP FUNCTIONING

    testURL ${API} '{"message":"OK"}'

    # FAIS DATA ENGINE API DOCS RESPONDS

    testURL ${API}/docs 'ui = SwaggerUIBundle'

    # FAIS KEYCLOAK SERVER TEST - THIS IS ONLY OPTIONALLY SETUP

    # curl http://kc.dev.fais.au/realms/fais_plus_dev/protocol/openid-connect/certs

    ####################################
    # FAIS API TEST TOKEN IS OF EXPECTED LENGTH FOR TEST USER
    ####################################
    
    TOKEN=$(${CURL} -X POST ${API}/auth -H 'Content-Type: application/json' -d '{"username":"u1234567", "password":"XXXXXXXX"}' | jq -r .access_token)

    if [ ${#TOKEN} -ge 1131 ] && [ ${#TOKEN} -le 1269 ] ; then
	printf "PASS: ${API}/auth returned a token of the correct length.\n"
    else
	printf "FAIL: ${API}/auth did NOT return a token of the expected length.\n"
	printf "===================================\n"
	printf "EXPECTED LENGTH 1131-1269 BUT GOT LENGTH ${#TOKEN}.\n"
	printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	printf "OBTAINED\n"
	printf "${TOKEN}"
	printf "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
    fi

    # FAIS API TEST ENDPOINT QUERY RETURNS A RESULT

    QUERY=data/programs
    ENDPOINT=${API}/${QUERY}
    RESPONSE=$(${CURL} -X GET ${ENDPOINT} -H "Authorization: Bearer ${TOKEN}" | mlr --json --opprint cat)
    testURL ${ENDPOINT} 'BCOMM' "${RESPONSE}"
    
    # FAIS API TEST ENDPOINT QUERY RETURNS A SPECIFIC NUMBER OF LINES
    #
    # This might change with changing data.
    
    NUM=$(printf "${RESPONSE}" | wc -l)
    EXP=100
    if [ ${NUM} -eq ${EXP} ]; then
	printf "PASS: ${API}/${QUERY} returned the correct number of lines.\n"
    else
	printf "FAIL: ${API}/${QUERY} did NOT return the expected number of lines.\n"
	printf "===================================\n"
	printf "EXPECTED TO BE ${EXP} LINES BUT GOT ${NUM}.\n"
	printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	printf "OBTAINED\n"
	printf "${RESPONSE}"
	printf "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
    fi

    # 20230124 NO LONGER HAS DATA: FAIS API TEST ENDPOINT QUERY STUDENT RETURNS A RESULT

    if false; then
       
    ENDPOINT=${API}/data/student/
    RESPONSE=$(${CURL} -X GET ${ENDPOINT} -H "Authorization: Bearer ${TOKEN}" | mlr --json --opprint cat)
    testURL ${ENDPOINT} 'student_id username sex degree intensity' "${RESPONSE}"

    # FAIS API TEST ENDPOINT QUERY RETURNS A SPECIFIC NUMBER OF LINES
    #
    # This might change with changing data.
    
    NUM=$(printf "${RESPONSE}" | wc -l)
    EXP=200
    if [ ${NUM} -eq ${EXP} ]; then
	printf "PASS: ${API}/data/student/ returned the correct number of lines.\n"
    else
	printf "FAIL: ${API}/data/student/ did NOT return the expected number of lines.\n"
	printf "===================================\n"
	printf "EXPECTED TO BE ${EXP} LINES BUT GOT ${NUM}.\n"
	printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	printf "OBTAINED\n"
	printf "${RESPONSE}"
	printf "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
    fi

    fi
       
    # FAIS KEYCLOAK TEST
    #
    # If keycloak fails then so will the authentication for the API.

    # TODO RUN THROUGH SSH ON SERVER
    #
    # 'curl http://localhost:8080/realms/fais_plus_dev/protocol/openid-connect/certs' 
    
else

    if [ "${LIN_ACCT}" = "gjwanupods" ]; then

	SOLID="https://${SUBDOMAIN}.${HOST_NAME}"

	# SOLID SERVER EXISTS

	testURL ${SOLID} 'http://www.w3.org/ns/pim/space#Storage'
	testURL ${SOLID}/idp/register/ '"confirmPassword":"string"'
	testURL ${SOLID}/idp/login/ '"email":"string"'

	# SOLID SERVER PODS POPULATED

	RESPONSE=$(${CURL} ${SOLID})
	NUM=$(echo "${RESPONSE}" | egrep '^<.+/> a ldp:Container' | wc -l)
	EXP=11
	if [ ${NUM} -ge ${EXP} ]; then
	    printf "PASS: Found ${NUM} PODs populated and expecting at least ${EXP}.\n"
	else
	    printf "FAIL: Expecting at least ${EXP} PODs but found ${NUM}.\n"
	    printf "===================================\n"
	    printf "EXPECTED TO BE ${EXP} PODS BUT GOT ${NUM}.\n"
	    printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	    printf "OBTAINED\n"
	    printf "${RESPONSE}"
	    printf "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
	fi

	if echo "${RESPONSE}" | grep 'gerry' >/dev/null; then
	    printf "PASS: Found the Gerry Tonga test POD\n"
	else
	    printf "FAIL: Did not find the Gerry Tonga test POD.\n"
	    printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	    printf "${RESPONSE}"
	    printf "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
	fi
	
	if echo "${RESPONSE}" | grep 'charlie-breugel' >/dev/null; then
	    printf "PASS: Found Charlie Breugel amongst Health Data PODs\n"
	else
	    printf "FAIL: Did not find Charlie Breugel amongst PODs.\n"
	    printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	    printf "${RESPONSE}"
	    printf "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
	fi
	
    fi

fi

########################################################################
if [ "${LIN_ACCT}" = "jmanutce" ]; then
########################################################################

	DASH="_dash-loading"
	WEB="<html>"
	DEPLOYED="Server Deployed"

	QUERY="https://${HOST_NAME}"
    # RESPONSE=$(${CURL} -${QUERY} | egrep "<html>")
	CMD=$(curl --silent ${QUERY})
	# RESPONSE=$(curl --silent -${QUERY} | egrep "<html>")
    
    # BZTE SERVER RETURNS A HTML PAGE OF THE DASH VISUALISATION
	# CHECK EGREP ON RETURNED PAGE RETURNS THE MATCHED HTML TAG
    
	RESPONSE=$(echo ${CMD} | egrep ${DASH})
    NUM=$(echo ${RESPONSE} | wc -l)
    EXP=1

    if [ ${NUM} -eq ${EXP} ]; then
	# printf "${QUERY} returned dashboard.\n"
	/usr/bin/osascript -e 'tell app "System Events" to display dialog "caddy returned dashboard"'
    else
	# printf "FAIL: ${API}/${QUERY} did NOT return the expected number of lines.\n"
	# printf "===================================\n"
	# printf "EXPECTED TO BE ${EXP} LINES BUT GOT ${NUM}.\n"
	# printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	# printf "OBTAINED\n"
	# printf "${RESPONSE}"
	/usr/bin/osascript -e 'tell app "System Events" to display dialog "curl didnt return dashboard\ncaddy failed\n DO systemctl stop caddy\n THEN enable, start, reload, status"'
	# printf "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
    fi

	RESPONSE=$(echo ${CMD} | egrep ${WEB})
    NUM=$(echo ${RESPONSE} | wc -l)
    EXP=1

    if [ ${NUM} -eq ${EXP} ]; then
	# printf "${QUERY} returned website.\n"
	/usr/bin/osascript -e 'tell app "System Events" to display dialog "caddy returned website"'
    else
	# printf "FAIL: ${API}/${QUERY} did NOT return the expected number of lines.\n"
	# printf "===================================\n"
	# printf "EXPECTED TO BE ${EXP} LINES BUT GOT ${NUM}.\n"
	# printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	# printf "OBTAINED\n"
	# printf "${RESPONSE}"
	/usr/bin/osascript -e 'tell app "System Events" to display dialog "curl didnt return website\ncaddy failed\n DO systemctl stop caddy\n THEN enable, start, reload, status"'
	# printf "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
    fi

fi

exit

# TODO

ENDPOINT="course/weekly_enrolment_class?course_code=COMP8430"
addLOG "${ENDPOINT}"
${CURL} -X GET $API/data/$ENDPOINT -H "Authorization: Bearer $TOKEN" | mlr --json --opprint head -n 10

ENDPOINT="course/get_provisional_final_grades?course_code=COMP8430"
addLOG "${ENDPOINT}"
${CURL} -X GET $API/data/$ENDPOINT -H "Authorization: Bearer $TOKEN" | mlr --json --opprint head -n 10

