#!/bin/bash
#
# Time-stamp: <Thursday 2023-06-29 11:38:20 +1000 Graham Williams>
#
# Support for common variables used across the scripts. We assume the
# bare metal server has been provisioned with Ubuntu and the LIN_JSON
# file contains the reported configuration.

# shellcheck disable=SC2034,SC1090

SCRIPT=$(basename "$0" .sh)

# Check if the current shell is bash.

if [ -z "$BASH_VERSION" ]; then
  printf "ERROR: %s: Please execute this script using Bash shell.\n" "$0"
  exit 1
fi

# If a host name has been supplied to the outer script then use that,
# and then do not load the Linode json configuration file. This is
# usually useful sometime after a deploy.sh and some script is run
# manually, and the latest cached linode.json has been overwritten by
# other deployments.

if [ -n "$1" ]; then
    HOST_NAME="$1"
    HOST_IP=$(dig +short "${HOST_NAME}")
fi

# Currently assumes using linode server. The specific Linode account to be used
# is specified as LIN_ACCT, which is specifically set in the host name
# specific shell script in configs.

LIN_ACCT=linode_account_name_should_be_specified_in_host_specific_configs_script

# Typical installations create a reverse proxy for a sub domain.
# The host name specific shell script in configs can update this
# value. The SUBDOMAIN should be set depending on the LIN_ACCOUNT
# currently comes from the file in the config directory.

SUBDOMAIN=none

# The linode-cli command generates a JSON file containing the server
# data. This data is saved to file by the provisioning scritpt. We use
# it here to extract the server specific information like the assigned
# IP address. TODO The file needs to be configs/${HOST_NAME}.json so
# that we get per host files and multiple deployments will not
# interefere with each other.

LIN_JSON=support/linode.json

# The token to access the Opalstack server for DNS updates should be
# in a secret (not shared) file.

OPAL_SECRET=support/opalstack.sec

# Variables used across multiple scripts:

if [[ -z "${HOST_NAME}" || "${SCRIPT}" == "provision_linode" ]]; then

     if [ -e ${LIN_JSON} ] && [ -s ${LIN_JSON} ]; then
	 HOST_NAME=$(jq -r '.[].label' ${LIN_JSON})
	 HOST_IP=$(jq -r '.[].ipv4[0]' ${LIN_JSON})
	 LIN_ID=$(jq -r '.[].id' ${LIN_JSON})

	 if [ -z "${HOST_NAME}" ]; then
	     printf "ERROR: %s: HOST_NAME not found in '%s'\n" "$0" "${LIN_JSON}"
	     exit 1
	 elif [ -z "${HOST_IP}" ]; then
	     printf "ERROR: %s: HOST_IP not found in '%s'\n" "$0" "${LIN_JSON}"
	     exit 1
	 fi
     else
	 printf "ERROR: %s: no host name supplied and no '%s\n'" "$0" "${LIN_JSON}"
	 exit 1
     fi
fi

if [ -e ${LIN_JSON} ]; then
    LIN_ID=$(jq -r '.[].id' ${LIN_JSON})
    if [ -z "${LIN_ID}" ]; then
	printf "ERROR: %s: LIN_ID not found in '%s'\n" "$0" "${LIN_JSON}"
	exit 1
    fi
fi

if [ -e ${OPAL_SECRET} ]; then
    OPAL_TOKEN=$(cat ${OPAL_SECRET})
else
    printf "ERROR: %s: OPAL_TOKEN file not found \n" "$0"
    exit 1
fi



# Support functions

beginLOG () {
    printf "%s" "$*"
    printf '#%.0s' {1..72} 1>&2
    printf "\n## $(date '+%Y%m%d %H%M%S') BEGIN %s\n##\n## " 1>&2 "${SCRIPT}"
    printf "%s\n" 1>&2 "$*"
}

addLOG () {
    printf "\n" 1>&2
    printf '#%.0s' {1..18} 1>&2
    printf "\n## $(date '+%Y%m%d %H%M%S') %s \n" 1>&2 "$*"
    printf '#%.0s' {1..18} 1>&2
    printf "\n" 1>&2
}

dotLOG () { printf "."; }

endLOG () {
    printf "\n##\n## $(date '+%Y%m%d %H%M%S') END %s\n" 1>&2 "${SCRIPT}"
    printf '#%.0s' {1..72} 1>&2
    printf "\n" 1>&2
    printf " DONE\n"
}

runSSH () {
    # For FAIS on ITS servers

    if [ "$1" = 'root' ] && [ ! -z "${ITS_SERVER}" ]; then
        _USER=${ITS_USER}
        _HOST=${ITS_SERVER}
        _COMMAND="sudo bash"
    else
        _USER=$1
        _HOST=${HOST_IP}
        _COMMAND=""
    fi

    printf "\n" 1>&2
    printf -- '-%.0s' {1..72} 1>&2
    printf "\n$(date '+%Y%m%d %H%M%S') SSH %s@$%s\n" 1>&2 "${_USER}" "{_HOST}"
    printf -- '-%.0s' {1..72} 1>&2
    printf "\n" 1>&2
    ssh -q -o "StrictHostKeyChecking=no" -o "LogLevel=ERROR" "${_USER}@${_HOST}" 1>&2 "${_COMMAND}"
}

CURL="curl --silent"

testURL () {

    URL=$1
    PAT="$2"
    if [ -n "$3" ]; then
	RESPONSE="$3"
    else
	RESPONSE="$(${CURL} "${URL}")"
    fi

    if echo "${RESPONSE}" | grep -E "${PAT}" >/dev/null; then
	printf "PASS: %s returned the expected response.\n" "${URL}"
	result=0
    else
	printf "FAIL: %s did NOT return the expected response:\n" "${URL}"
	printf "===================================\n"
	printf "EXPECTED TO CONTAIN\n\n"
	printf "%s\n" "${PAT}"
	printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	printf "OBTAINED\n\n"
	printf "%s" "${RESPONSE}"
	printf "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
	result=1
    fi

    return $result
}

# Include deployment specific overrides so that this file needs no
# modifications for specific deployments. The config file is
# required. 20221226 However, it seems that it is primarily to set
# LIN_ACCOUNT and SUBDOMAIN. Perhaps move these into a single JSON
# file to do this fine tuned config or from the command line?

CONFIGS=./configs/${HOST_NAME}.sh

if [[ -e ${CONFIGS} ]]; then
    . "${CONFIGS}";
else
    printf "ERROR: %s: No config file '%s'.\n" "$0" "S{CONFIGS}"
    exit 1
fi

# For the provisioned server add the users listed in the USERS
# file. LIN_ACCT will be specified in the CONFIGS file.

USERS=support/${LIN_ACCT}_users.json
