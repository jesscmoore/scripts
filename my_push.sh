#!/bin/bash
#
# Time-stamp: Wednesday 2026-03-18 14:28:16 Jess Moore
#
# Push local document to remote Nextcloud folder
#
# Usage: my_push.sh [args...]

function usage() {
    echo "Usage: my_push.sh [filename] [remotesubdir]"
    echo ""
    echo "Description: Push local document to remote Nextcloud folder."
    echo ""
    echo "Arguments:"
    echo "  filename:      Name of file (must include extension)."
    echo "  remotesubdir:  Sub directory in remote location"
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

# Check local file exists
if [[ ! -e "$FILE" ]]; then
  echo "$FILE does not exist."
  exit 1
fi

if [[ "${user}" == "u9904893" ]]; then 

    if [[ -f "${REM_DIR}/${FILE}" ]]; then 
        echo "Backing up remote file to *.bak"
        cp -p "${REM_DIR}/${FILE}" "${REM_DIR}/${FILE}.bak"
    fi
    
    echo "Pushing to ${REM_DIR}..."    
    cp -p "$FILE" "${REM_DIR}"/.
    
    echo "Files on Nextcloud:"
    FILES_REM=$(find "${REM_DIR}" -name "${FILE}*")
    for f in $FILES_REM
    do
        ls -lt "$f"
    done
    
fi

echo "Done"

FILES_LOC=$(find . -name "${FILE}*")
echo "Local files:"
for f in $FILES_LOC
do
	ls -lt "$f"
done
