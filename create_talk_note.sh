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
    echo "speakers:      Comma separated attendees surrounded "
    echo "               in quotes."
    echo "affiliations:  Optionally, also provide comma separated affiliations"
    echo "               surrounded in quotes."
    echo "meeting_group: Optional, name of meeting group, eg. 'Solid Practitioners'"
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

if [ -n "$3" ]; then
    MTG=$3
fi

# Make file name with syntax YYMMDD-speakers.md
# Convert speakers to lc, replace ", " with line end "\n"
# SPEAKERS_SUMM=$(echo "${SPEAKERS}" | awk '{print tolower($0);}' | sed 's/  / /g;s/ //g;s/,/\n/g')

## Remove double spaces and line split
SPEAKERS_LS=$(echo "${SPEAKERS}" | sed 's/  / /g;s/, /\n/g')

# Get date in formats for file and title
DATE_SUMM=$(date "+%Y%m%d")
DATE_STR=$(date "+%d %b %Y")

echo "Speakers: "
echo "${SPEAKERS_LS}"

# SPEAKER1=$(echo "$SPEAKERS_SUMM" | head -n 1)
N_SPEAKERS=$(echo "$SPEAKERS_LS" | wc -l)

echo "N speakers: $N_SPEAKERS"

# Create speaker array
declare -a SPEAKER_ARR
for i in $(seq 0 $((N_SPEAKERS - 1))); do

    line_num=$((i+1))
    SPEAKER_ARR[i]="$(echo "$SPEAKERS_LS" | awk "NR==$line_num")"
    
    echo "$i: ${SPEAKER_ARR[i]}"

    if [[ "$i" == "0" ]]; then
    
        SPEAKER1=$(echo "${SPEAKER_ARR[i]}" | awk '{print tolower($0);}' | sed 's/ //g')
        echo "Speaker 1: ${SPEAKER1}"
    
    elif [[ "$i" == "1" ]]; then

        # Form speaker string part of filename for 2 speakers
        SPEAKER2=$(echo "${SPEAKER_ARR[i]}" | awk '{print tolower($0);}' | sed 's/ //g')
        echo "Speaker 2: ${SPEAKER2}"

    fi 
    
done

# Form speaker string part of filename
if [[ "$N_SPEAKERS" == 1 ]]; then 
    # 1 speaker
    SPEAKER_STR="${SPEAKER1}"
    echo "defining speaker_str for 1 speaker"
elif [[ "$N_SPEAKERS" == 2 ]]; then 
    # 2 speakers
    SPEAKER_STR="${SPEAKER1}_${SPEAKER2}"
    echo "defining speaker_str for 2 speakers"
elif [[ "$N_SPEAKERS" -gt 2 ]]; then 
    # More than 2 speakers
    SPEAKER_STR="${SPEAKER1}_etal"
    echo "defining speaker_str for > 2 speakers"

fi

echo "Speaker string:${SPEAKER_STR}"

# Set talk note title and filename
if [[ -n $MTG ]]; then 
    # Title: use mtg name if provided
    TITLE="${MTG} - ${DATE_STR}"
    # Filename: use mtg name if provided
    FILENAME="${DATE_SUMM}-${MTG}.md"
    
else 
    TITLE="${SPEAKERS} on XYZ"
    FILENAME="${DATE_SUMM}-${SPEAKER_STR}.md"
fi
    

# Write header
cat > "${FILENAME}" << EOF
# ${TITLE}

*Speakers: ${SPEAKERS}
*Affiliations: ${AFFILS}*

*Date: ${NOW} ${AUTHOR}*

## Summary

- Foo
- Foo2

## Discussion

EOF


# Write speaker subheading sections
for i in $(seq 0 $((N_SPEAKERS - 1))); do

cat >> "${FILENAME}" << EOFF
### ${SPEAKER_ARR[i]}



EOFF

done


# Write footer
cat >> "${FILENAME}" << EOFFF
<!-- markdownlint-disable-file MD009 MD012 MD013 MD036 -->
<!-- MD009 - no trailing spaces -->
<!-- MD012 - no multiple blanks -->
<!-- MD013 - line limit -->
<!-- MD036 - emphasised text as heading -->
EOFFF

ls -l "${FILENAME}"
echo "Done."
