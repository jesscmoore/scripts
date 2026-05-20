#!/bin/bash
#
# Time-stamp: Sunday 2026-04-26 Jess Moore
#
# Pull local document from a remote sync folder

function usage() {
    echo "Usage: my_pull.sh [-n|-p|-s|-o folder] [remotesubdir] [filename]"
    echo ""
    echo "Description: Pull a document from a remote sync folder."
    echo "This script copies a document from a subdirectory of the chosen"
    echo "remote folder into the current directory. Check the remote"
    echo "afterwards to confirm syncing is up to date."
    echo ""
    echo "Flags (exactly one required):"
    echo "  -n             Nextcloud folder  (~/Documents/Nextcloud)"
    echo "  -p             Private folder    (~/Documents/private)"
    echo "  -s             Sharepoint folder (~/Australian National University)"
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

while getopts ":hnpso:" opt; do
    case $opt in
        h) usage ;;
        n) BASE_DIR="${HOME}/Documents/Nextcloud" ;;
        p) BASE_DIR="${HOME}/Documents/private" ;;
        s) BASE_DIR="${HOME}/Australian\ National\ University" ;;
        o) BASE_DIR="${HOME}/Documents/${OPTARG}" ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

if [[ -z "$BASE_DIR" || $# -ne 2 ]]; then
    usage
fi

REM_SUB_DIR="$1"
FILE=$2

# User
user=$(whoami)
REM_DIR="${BASE_DIR}/${REM_SUB_DIR}"

# Check remote dir exists
if [[ ! -d "${REM_DIR}" ]]; then
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

    # Backup local file before overwrite
    if [[ -f "${FILE}" ]]; then
        echo "Backing up local file to *.bak"
        cp -p "${FILE}" "${FILE}.bak"
    fi

    echo "Files on remote:"
    # FILES_REM=$(find "${REM_DIR}" -name "${FILE}*")
    # for f in $FILES_REM
    # do
    #     stat "$f"
    #     # ls -lt "$f"
    # done
    mapfile -t FILES_REM < <(find "${REM_DIR}" -type f -name "${FILE}*")
    for f in "${FILES_REM[@]}"; do
        stat -l "$f"
    done

    echo "Pulling from ${REM_DIR}..."
    cp -p "${REM_DIR}/${FILE}" "${FILE}"

fi

echo "Done"

# FILES_LOC=$(find . -name "${FILE}*")
echo "Local files:"
# for f in $FILES_LOC
# do
#     stat "$f"
# 	# ls -lt "$f"
# done
mapfile -t FILES_LOC < <(find . -type f -name "${FILE}*")
for f in "${FILES_LOC[@]}"; do
    stat -l "$f"
done
