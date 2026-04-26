#!/bin/bash
#
# Time-stamp: Sunday 2026-04-26 Jess Moore
#
# Push local document to a remote sync folder
#
# Usage: my_push.sh [-n|-p|-o folder] [filename] [remotesubdir]

function usage() {
    echo "Usage: my_push.sh [-n|-p|-o folder] [filename] [remotesubdir]"
    echo ""
    echo "Description: Push local document to a remote sync folder."
    echo "This script copies a local document into a subdirectory of the"
    echo "chosen remote folder. Check the remote afterwards to confirm"
    echo "syncing is up to date."
    echo ""
    echo "Flags (exactly one required):"
    echo "  -n             Nextcloud folder  (~/Documents/Nextcloud)"
    echo "  -p             Private folder    (~/Documents/private)"
    echo "  -o folder      Other folder      (~/Documents/<folder>)"
    echo ""
    echo "Arguments:"
    echo "  filename:      Name of file (must include extension)."
    echo "  remotesubdir:  Subdirectory within the remote folder."
    echo ""
    exit 1
}

BASE_DIR=""

[[ "$1" == "--help" ]] && usage

while getopts ":hnpo:" opt; do
    case $opt in
        h) usage ;;
        n) BASE_DIR="${HOME}/Documents/Nextcloud" ;;
        p) BASE_DIR="${HOME}/Documents/private" ;;
        o) BASE_DIR="${HOME}/Documents/${OPTARG}" ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

if [[ -z "$BASE_DIR" || $# -ne 2 ]]; then
    usage
fi

FILE=$1
REM_SUB_DIR=$2

# User
user=$(whoami)
REM_DIR="${BASE_DIR}/${REM_SUB_DIR}"

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

    echo "Files on remote:"
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
