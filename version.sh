#!/bin/bash
#
# Time-stamp: <Saturday 2025-09-13 14:23:29 Jess Moore>
#

IFS=,
declare -a TYPES
TYPES=('pdf' 'docx' 'xlsx')
joined_types="${TYPES[*]}"

function usage() {
    echo "Usage: version.sh [file] [type]"
    echo ""
    echo "Description: Copies the current output pdf, appending version"
    echo "number, and writing to current_tagged_versions folder, and moves"
    echo "earlier versions in the current folder to the earlier_versions"
    echo "folder."
    echo ""
    echo "Arguments:"
    echo "  file:      Filename to version excluding suffixes (Default: none)."
    echo "  type:      File type to version (Options: ${joined_types}, default: pdf)."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

FILE=$1

# Default type
TYPE='pdf'

if [[ $# -eq 2 ]]; then
        TYPE=$2
fi

# Check valid column provided
case "${TYPE}" in
    pdf|docx|xlsx)

        echo "Valid file type provided.";;

    *)
        echo "Supported types: ${TYPES[*]}.";
        usage;;

esac;

FILE=$(basename "$FILE")
echo "Version tagging file: ${FILE}.${TYPE}"

# Setup directories
ARCHIVE_DIR="earlier_versions"
CURRENT_DIR="current_tagged_versions"

if [ ! -d "$ARCHIVE_DIR" ]; then
  mkdir -p "$ARCHIVE_DIR"
  echo "Created ${ARCHIVE_DIR}."
fi

if [ ! -d "$CURRENT_DIR" ]; then
    mkdir -p "${CURRENT_DIR}"
    echo "Created ${CURRENT_DIR}."
    NEW_VERSION="v1"
fi

# Increment old version number to make new version number
NCURR_FILES=$(find ${CURRENT_DIR}/.  -iname "${FILE}*.${TYPE}" 2>/dev/null | wc -l)

if [[ $NCURR_FILES -eq 0 ]]; then
        NEW_VERSION="v1"
        OLD_VERSION="nil"
        echo "No current files found."
else
    EXISTING_VERSION_NUM=$(find ${CURRENT_DIR}/.  -iname "${FILE}*.${TYPE}" | grep -oE '[0-9]+')
    # echo "Before: Found files version numbers in current folder:"
    # echo "${EXISTING_VERSION_NUM}"
     IFS=$'\n'
    OLD_VERSION=$(echo "${EXISTING_VERSION_NUM[*]}" | sort -nr | head -n1)
    NEW_VERSION=$((OLD_VERSION + 1))
    OLD_VERSION="v${OLD_VERSION}"
    NEW_VERSION="v${NEW_VERSION}"
    # Earlier version file name
    OLD_FILE="${FILE}_${OLD_VERSION}.${TYPE}"

    echo ""
    echo "Before:"
    find ${CURRENT_DIR}/.  -iname "${FILE}*.${TYPE}"
fi

# Version tagged file name for current file
NEW_FILE="${FILE}_${NEW_VERSION}.${TYPE}"


# Copy to current folder
cp -p "${FILE}.${TYPE}" "${CURRENT_DIR}/${NEW_FILE}"

# Move older version to earlier versions folder
mv "${CURRENT_DIR}/${OLD_FILE}" "${ARCHIVE_DIR}/${OLD_FILE}"

# Show results
echo ""
echo "After:"
# Matching files in current dir
find ${CURRENT_DIR}/.  -iname "${FILE}*.${TYPE}" | while IFS='' read -r curr_line
do
    ls -lt "$curr_line"
done
# Matching files in archive dir
find ${ARCHIVE_DIR}/.  -iname "${FILE}*.${TYPE}" | while IFS='' read -r archive_line
do
    ls -lt "$archive_line"
done
