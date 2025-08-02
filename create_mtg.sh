#!/bin/bash
#
# Time-stamp: <Friday 2024-10-07 11:22:02 Jess Moore>
#
# Creates a markdown meeting file
#
# Usage: bash create_mtg.sh 20230407-notes.md "Mtg with xyz" "Jane, Bob, Liz, Sam" "ANU"

function usage() {
    echo "Usage: $(basename "$0") 'title' 'attendee1, attendee2' 'place'"
    echo ""
    echo "Description: This script creates a markdown file for"
    echo "             meeting notes prepopulated with fields: title, "
    echo "             date, author, location, and headings for actions, "
    echo "             talking points, and discussion."
    echo ""
    echo "Arguments:"
    echo "  title:     Meeting title in quotes."
    echo "  attendees: Comma separated attendees surrounded "
    echo "             in quotes."
    echo "  place:     Meeting location in quotes, e.g. Teams."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 ]]; then
    usage
fi

AUTHOR=$(id -F)
NOW=$(date "+%A %Y-%m-%d %H:%M:%S")
TITLE=$1
ATTENDEES=$2
PLACE=$3

## Form filename with syntax YYmmdd-person1_person2_author.md
# Convert attendees to lc, replace ", " with "_"
PEOPLE_SUMM=$(echo "$ATTENDEES" | awk '{print tolower($0);}' | sed 's/,/ /g;s/  / /g;s/ /_/g')
# Get lowercase firstname of author
AUTHOR_SUMM=$(echo "$AUTHOR" | awk '{print tolower($1);}')
DATE_SUMM=$(date "+%Y%m%d")
FILENAME="${DATE_SUMM}-${PEOPLE_SUMM}_${AUTHOR_SUMM}.md"

cat > "${FILENAME}" << EOF
# ${TITLE}

*Date: ${NOW} ${AUTHOR}*

*Attendees: ${ATTENDEES}, ${AUTHOR}*

*Location: ${PLACE}*

## Actions

- Foo
- Foo2

## Agenda

1.
2.
3.
4. Next actions/mtg

## Talking Points

1.
2.
3.

## Discussion





<!-- markdownlint-disable-file MD036 -->
EOF
