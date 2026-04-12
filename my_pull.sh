#!/bin/bash
#
# Time-stamp: Sunday 2026-04-12 09:52:33 Jess Moore
#
# Push local document to remote Nextcloud folder
#
# Usage: my_pull.sh [args...]

function usage() {
    echo "Usage: my_pull.sh [filename] [remotesubdir]"
    echo ""
    echo "Description: Pull local document from remote Nextcloud folder."
    echo "This script pulls document from local sync drive of remote Nextcloud"
    echo "folder. Check Nextcloud online afterwards to confirm syncing is up to"
    echo "date."
    echo ""
    echo "Arguments:"
    echo "  filename:      Name of file (must include extension)."
    echo "  remotesubdir:  Sub directory on local sync dir to remote location"
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}


if [[ $# -ne 2 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

FILE=$1
REM_SUB_DIR=$2


# User
user=$(whoami)
REM_DIR="${HOME}/Documents/Nextcloud/${REM_SUB_DIR}"

# Check remote dir exists
if [[ ! -d ${REM_DIR} ]]; then 
    echo "Remote directory does not exist"
    exit 1
else 
    echo "Remote directory: ${REM_DIR}"
fi

# Check remote file exists
if [[ ! -e "${REM_DIR}/$FILE" ]]; then
  echo "$FILE does not exist."
  exit 1
fi

if [[ "${user}" == "u9904893" ]]; then 

    if [[ -f "${FILE}" ]]; then 
        echo "Backing up local file to *.bak"
        cp -p "${FILE}" "${FILE}.bak"
    fi
    
     echo "Files on Nextcloud:"
    FILES_REM=$(find "${REM_DIR}" -name "${FILE}*")
    for f in $FILES_REM
    do
        ls -lt "$f"
    done
    
    while true; do
        read -r -p "Do you wish to pull ${FILE} from Nextcloud?: " yn
        case $yn in
            [Yy]* ) echo "Proceeding..."; break;;
            [Nn]* ) echo "Aborting..."; exit;;
            * ) echo "Please answer y or n.";;
        esac
    done    
    
    echo "Pulling from ${REM_DIR}..."    
    cp -p "${REM_DIR}/${FILE}" "${FILE}"
    
fi

echo "Done"

FILES_LOC=$(find . -name "${FILE}*")
echo "Local files:"
for f in $FILES_LOC
do
	ls -lt "$f"
done
