#!/bin/bash
#
# Time-stamp: <Friday 2023-04-07 14:22:02 Jess Moore>
#
# Creates a markdown file
#
# Usage: bash create_md.sh 20230407-notes.md "Mtg with xyz"

NAME=`id -F`
NOW=`date "+%A %Y-%m-%d %H:%M:%S"`
FILENAME=$1
TITLE=$2

cat > ${FILENAME} << EOF
# ${TITLE}
*Date: ${NOW} ${NAME}*
EOF