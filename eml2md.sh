#!/bin/bash
#
# Time-stamp: <Monday 2025-08-04 11:05:05 Jess Moore>
#
# Uses pandoc to convert eml file to markdown
#
# Usage: eml2md.sh [args...]

function usage() {
    echo "Usage: eml2md.sh file"
    echo ""
    echo "Description: Uses pandoc to convert eml file to markdown."
    echo ""
    echo "Arguments:"
    echo "  file: Filename of .eml file."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

FILE=$1
BASENAME=${FILE%.*}

# Convert file
pandoc -f html -o "${BASENAME}".md "${BASENAME}".eml

CONTENT=$(cat "${BASENAME}".md)

# Remove content before " To: "
START_CONTENT=' To: '
RES="To: "${CONTENT#*"$START_CONTENT"}

# Remove backslashes
RES="${RES//\\/}"

# Remove div tags
RES="${RES//<div>/}"
RES="${RES//<\/div>/}"

# Remove ending https line
END_CONTENT='![](https:'
RES="${RES%"$END_CONTENT"*}"

# Write cleaned content to file
echo "$RES" > "${BASENAME}".md

ls -l "$BASENAME"*
