#!/bin/bash
#
# Time-stamp: <Sunday 2025-08-03 06:05:10 Jess Moore>
#
# Creates a markdown file for jotting notes at a talk
#
# Usage: bash create_talk_notes.sh "Jane, Bob, Liz, Sam" "ANU"

function usage() {
    echo "Usage: $(basename "$0") 'speaker1, speaker2' ['affil1, affil2']"
    echo ""
    echo "Description: This script creates a markdown file for"
    echo "             talk notes prepopulated with spearker names, "
    echo "             optionally their affiliations, date, "
    echo "             summary, and discussion."
    echo ""
    echo "Arguments:"
    echo "  speakers:  Comma separated attendees surrounded "
    echo "             in quotes."
    echo "  affiliations: Optionally, also provide comma separated affiliations"
    echo "             surrounded in quotes."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

NOW=$(date "+%A %Y-%m-%d %H:%M:%S")
AUTHOR=$(id -F)
SPEAKERS=$1

if [ -n "$2" ]; then
    AFFILS=$2
else
    AFFILS="To be determined"
fi

# Make file name with syntax YYMMDD-speakers.md
# Convert speakers to lc, replace ", " with line end "\n"
SPEAKERS_SUMM=$(echo "${SPEAKERS}" | awk '{print tolower($0);}' | sed 's/  / /g;s/ //g;s/,/\n/g')
DATE_SUMM=$(date "+%Y%m%d")

echo "Speakers: ${SPEAKERS_SUMM}"

SPEAKER1=$(echo "$SPEAKERS_SUMM" | head -n 1)
N_SPEAKERS=$(echo "$SPEAKERS_SUMM" | wc -l)

echo "N speakers: $N_SPEAKERS"

# Form new paper name
if [ "$N_SPEAKERS" -eq "1" ]; then

    # 1 speaker
    SPEAKER_STR=$SPEAKER1

elif [ "$N_SPEAKERS" -eq "2" ]; then

    # 2 speakers
    SPEAKER2=$(echo "$SPEAKERS_SUMM" |tail -n 1)
    SPEAKER_STR="${SPEAKER1}_${SPEAKER2}"

else
    # More than 2 authors
    SPEAKER_STR="${SPEAKER1}_etal"

fi

FILENAME="${DATE_SUMM}-${SPEAKER_STR}.md"

cat > "${FILENAME}" << EOF
# ${SPEAKERS} on XYZ

*Affiliations: ${AFFILS}*

*Date: ${NOW} ${AUTHOR}*

## Summary

- Foo
- Foo2

## Discussion





<!-- markdownlint-disable-file MD009 MD013 MD036 -->
<!-- MD013 - line limit -->
<!-- MD009 - no trailing spaces -->
<!-- MDo36 - emphasised text as heading -->
EOF

ls -l "${FILENAME}"
echo "Done."
