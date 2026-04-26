#!/bin/bash
#
# Time-stamp: Sunday 2026-04-26 Jess Moore
#
# Check how to share document or update local or remote of document
#
# Usage: update_doc.sh [-n|-p|-o folder] [filename] [remotesubdir]

function usage() {
    echo "Usage: update_doc.sh [-n|-p|-o folder] [filename] [remotesubdir]"
    echo ""
    echo "Description: Check how to share document or update local or remote of document."
    echo ""
    echo "Flags (exactly one required):"
    echo "  -n             Nextcloud folder  (~/Documents/Nextcloud)"
    echo "  -p             Private folder    (~/Documents/private)"
    echo "  -o folder      Other folder      (~/Documents/<folder>)"
    echo ""
    echo "Arguments:"
    echo "  filename:      Name of file (must include extension)"
    echo "  remotesubdir:  Subdirectory within the remote folder."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

BASE_DIR=""
FLAG_ARG=()

[[ "$1" == "--help" ]] && usage

while getopts ":hnpo:" opt; do
    case $opt in
        h) usage ;;
        n) BASE_DIR="${HOME}/Documents/Nextcloud"; FLAG_ARG=("-n") ;;
        p) BASE_DIR="${HOME}/Documents/private";   FLAG_ARG=("-p") ;;
        o) BASE_DIR="${HOME}/Documents/${OPTARG}"; FLAG_ARG=("-o" "${OPTARG}") ;;
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

ACTION=""
if [[ ${MODTIME_REM} > ${MODTIME_LOC} ]]; then
    echo "Remote file is more recent -> pull FROM remote"
    ACTION="pull"
elif [[ ${MODTIME_REM} == "${MODTIME_LOC}" ]]; then
    echo "Files are up to date (same)"
else
    echo "Local file is more recent -> push TO remote"
    ACTION="push"
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

SCRIPT_DIR="$(dirname "$0")"

if [[ "$ACTION" == "pull" ]]; then
    while true; do
        read -r -p "Pull ${FILE} from remote now? [y/n]: " yn
        case $yn in
            [Yy]* ) bash "${SCRIPT_DIR}/my_pull.sh" "${FLAG_ARG[@]}" "${FILE}" "${REM_SUB_DIR}"; break;;
            [Nn]* ) echo "Skipping."; break;;
            * ) echo "Please answer y or n.";;
        esac
    done
elif [[ "$ACTION" == "push" ]]; then
    while true; do
        read -r -p "Push ${FILE} to remote now? [y/n]: " yn
        case $yn in
            [Yy]* ) bash "${SCRIPT_DIR}/my_push.sh" "${FLAG_ARG[@]}" "${FILE}" "${REM_SUB_DIR}"; break;;
            [Nn]* ) echo "Skipping."; break;;
            * ) echo "Please answer y or n.";;
        esac
    done
fi

echo "Done"
