#!/bin/bash
#
# Time-stamp: Wednesday 2026-03-18 14:04:34 Jess Moore
#
# Check how to share document or update local or remote of document
#
# Usage: update_doc.sh [args...]

function usage() {
    echo "Usage: update_doc.sh [filename] [remotesubdir]"
    echo ""
    echo "Description: Check how to share document or update local or remote of document."
    echo ""
    echo "Arguments:"
   echo "   filename:      Name of file (must include extension)"
    echo "  remotesubdir:  Sub directory in remote location"
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}


if [[ $# -ne 2 || $* == *"help"* || $* == *"-h"* ]]; then
    echo "Must have 2 arguments"
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
  echo "Local $FILE does not exist."
  exit 1
fi

if [[ "${user}" != "u9904893" ]]; then 
    echo "User must be jmoore's id"
    exit 1
fi


MODTIME_REM=$(stat -f %Sm -t %Y%m%d%H%M%S "${REM_DIR}/$FILE")

if [[ -f "${REM_DIR}/$FILE" ]]; then
    echo "Remote file $FILE: ${MODTIME_REM}"
else 
    echo "Remote file $FILE does not yet exist"
fi

MODTIME_LOC=$(stat -f %Sm -t %Y%m%d%H%M%S "$FILE")
# Extra white space for aligned modtimes
echo "Local file  $FILE: ${MODTIME_LOC}"

if [[ ${MODTIME_REM} > ${MODTIME_LOC} ]]; then 
    echo "Remote file is more recent -> pull FROM remote"
elif [[ ${MODTIME_REM} == "${MODTIME_LOC}" ]]; then
    echo "Files are up to date (same)"
else 
    echo "Local file is more recent -> push TO remote"
fi

BASEFILE=$(basename "${FILE}")

echo "Remote files:"
FILES_REM=$(find "${REM_DIR}" -name "${BASEFILE}*")
for f in $FILES_REM
do
    ls -lt "$f"
done

echo "Local files:"
FILES_LOC=$(find . -name "${BASEFILE}*" -depth)
for f in $FILES_LOC
do
    ls -lt "$f"
done
    
echo "Done"
