#!/bin/bash
#
# Time-stamp: <Friday 2023-04-07 14:22:02 Jess Moore>
#
# Creates a markdown file
#
# Usage: bash create_md.sh 20230407-notes.md "Project K"

function usage() {
    echo "Usage: create_md.sh [filename] [title]"
    echo ""
    echo "Description: create markdown file with filename 'filename' and title 'title'"
    echo ""
    echo "Arguments:"
    echo "  filename: Filename"
    echo "  title:    Title in file."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}


if [[ $# -ne 2 || $* == *"help"* || $* == *" -h "* ]]; then
    usage
fi

NAME=$(id -F)
NOW=$(date "+%A %Y-%m-%d %H:%M:%S")
FILENAME=$1
TITLE=$2

cat > "${FILENAME}" << EOF
# ${TITLE}

*Date: ${NOW} ${NAME}*



<!-- markdownlint-disable-file  MD009 MD012 MD013 MD029 MD036 -->
<!-- markdownlint-disable-file MD009 MD012 MD013 MD036 -->
<!-- MD009 - no trailing spaces -->
<!-- MD012 - no multiple blanks -->
<!-- MD013 - line limit -->
<!-- MD036 - emphasised text as heading -->
EOF
