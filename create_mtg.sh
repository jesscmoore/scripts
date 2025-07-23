#!/bin/bash
#
# Time-stamp: <Friday 2024-10-07 11:22:02 Jess Moore>
#
# Creates a markdown meeting file
#
# Usage: bash create_mtg.sh 20230407-notes.md "Mtg with xyz" "Jane, Bob, Liz, Sam" "ANU"

NAME=$(id -F)
NOW=$(date "+%A %Y-%m-%d %H:%M:%S")
FILENAME=$1
TITLE=$2
ATTENDEES=$3
PLACE=$4

cat > "${FILENAME}" << EOF
# ${TITLE}

<!-- markdownlint-disable-file MD036 -->

*Date: ${NOW} ${NAME}*

*Attendees: ${ATTENDEES}*

*Location: ${PLACE}*

## Actions

- Foo
- Foo2

## Talking Points

1.
2.
3.
4. Next actions/mtg

## Discussions
EOF
