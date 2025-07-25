#!/bin/bash
#
# Time-stamp: <Friday 2025-07-25 21:12:02 Jess Moore>
#
# Renames academic paper using bibfile to YYYY_author.pdf
#
# Usage: bash rename_paper.sh "file" "bibfile"

function usage() {
    echo "Usage: $(basename "$0") 'file' 'bibfile'"
    echo ""
    echo "Description: This script renames a research paper "
    echo "             to a standardised filename of "
    echo "             YYYY_Author1.pdf (1 author)"
    echo "             YYYY_Author1_Author2.pdf (2 authors)"
    echo "             YYYY_Author1_etal.pdf (3 or more authors)"
    echo "             using the bibfile data. "
    echo ""
    echo "Arguments:"
    echo "  file:      Academic paper filename."
    echo "  bibfile:   Bib filename"
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 ]]; then
    usage
fi

PAPERNAME=$1
BIB=$2
BIBXML="$BIB".xml

# Check paper exists
if [ ! -f "$PAPERNAME" ]; then
  echo "Error: Paper ${PAPERNAME} does not exist. Check filename is correct."
  exit 1
fi

# Check bib file exists
if [ ! -f "$BIB" ]; then
  echo "Error: Bib file ${BIB} does not exist. Check filename downloaded and correct."
  exit 1
fi

# Convert ris citation file to xml format
ris2xml "$BIB" > "$BIBXML"

# Extract first author from xml
AUTHORS=$(xml sel -N x="http://www.loc.gov/mods/v3" -t -v "//x:mods[@ID]/x:name[@type='personal']/x:namePart[@type='family']" "$BIBXML")

AUTHOR1=$(echo "$AUTHORS" | head -n 1)
N_AUTHORS=$(echo "$AUTHORS" | wc -l)

# Extract publication year from xml
DATE_RANGE=$(xml sel -N x="http://www.loc.gov/mods/v3" -t -v "//x:mods[@ID]/x:part/x:date" "${BIBXML}")
# A date is typically formatted as
# yyyymmdd = 8 characters or
# yyyy-mm-dd = 10 characters or
# XXXXXXXX-yy/mm/dd > 10 characters
# Use length to determine year extraction
if [[ ${#DATE_RANGE} -gt 10 ]]; then
  # Date range provided
  echo "${DATE_RANGE}: ${#DATE_RANGE}"
  YEAR=$(echo "$DATE_RANGE" | cut -d '-' -f 2 | cut -c1-4)
  echo "$YEAR"
else
  # Single date provided
  echo "${DATE_RANGE}: ${#DATE_RANGE}"
  YEAR=$(echo "$DATE_RANGE" | cut -c1-4)
  echo "$YEAR"
fi


# Form new paper name
if [ "$N_AUTHORS" -eq "1" ]; then

    AUTHOR_STR=$AUTHOR1

elif [ "$N_AUTHORS" -eq "2" ]; then

    AUTHOR2=$(echo "$AUTHORS" |head -n 2 | tr '\n' '_')
    AUTHOR_STR="${AUTHOR1}_${AUTHOR2}"

elif [ "$N_AUTHORS" -gt "2" ]; then

    AUTHOR_STR="${AUTHOR1}_etal"

else

    echo "Error: Author names were not parsed from ${BIB}."
    exit 1

fi
NEWPAPERNAME="${YEAR}_${AUTHOR_STR}.pdf"

echo "Old paper name: ${PAPERNAME}"
echo "New paper name: ${NEWPAPERNAME}"
echo "Successfully renamed paper"
ls -l "${PAPERNAME}"

# Rename paper
mv "${PAPERNAME}" "${NEWPAPERNAME}"
ls -l "${NEWPAPERNAME}"

# Clean up
rm "$BIBXML"

echo "Done."
