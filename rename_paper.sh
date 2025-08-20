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

# Check bib file format and convert if necessary
EXT="${BIB##*.}"
BASENAME=$(basename "$BIB")

case "${EXT}" in
'xml')
    BIBXML=$BIB;;
'ris'|'nbib')
    echo "Converting ${BIB} to .xml format."
    BIBXML="${BASENAME}.xml";

    case "${EXT}" in

        'ris')
            ris2xml "$BIB" > "$BIBXML";;
        'nbib')
            nbib2xml "$BIB" > "$BIBXML";;
    esac;;
*)
    echo "Error ${BIB} is not in a supported file format.";
    Exit 1;;
esac


# Extract first author from xml
AUTHORS=$(xml sel -N x="http://www.loc.gov/mods/v3" -t -v "//x:mods[@ID]/x:name[@type='personal']/x:namePart[@type='family']" "$BIBXML")

echo "Authors: ${AUTHORS}"

if [[ -z $AUTHORS ]]; then
    echo "Error: Author names were not parsed from ${BIB}."
    exit 1
fi

AUTHOR1=$(echo "$AUTHORS" | head -n 1)
N_AUTHORS=$(echo "$AUTHORS" | wc -l)

# Extract publication year from xml
DATE_RANGE=$(xml sel -N x="http://www.loc.gov/mods/v3" -t -v "//x:mods[@ID]/x:part/x:date" "${BIBXML}")

# Try alternate parametr if <date> not found
if [[ -z $DATE_RANGE ]]; then

    DATE_RANGE=$(xml sel -N x="http://www.loc.gov/mods/v3" -t -v "//x:mods[@ID]/x:originInfo/x:dateIssued" "${BIBXML}")

fi

# Exit if not found
if [[ -z $DATE_RANGE ]]; then
    echo "Error: Date was not parsed from ${BIB}."
    exit 1
fi

# A date is typically formatted as
# yyyymmdd = 8 characters or
# yyyy-mm-dd = 10 characters or
# XXXXXXXX-yy/mm/dd > 10 characters
# yyyy-dd mmm yyyy through to dd mmm yyyy > 20 characters
# Use length to determine year extraction
if [[ ${#DATE_RANGE} -gt 20 ]]; then
  # Verbose date range provided
  echo "${DATE_RANGE}: ${#DATE_RANGE} (verbose)"
  YEAR=$(echo "$DATE_RANGE" | cut -d '-' -f 1)
elif [[ ${#DATE_RANGE} -gt 10 ]]; then
  # Date range provided
  echo "${DATE_RANGE}: ${#DATE_RANGE}"
  YEAR=$(echo "$DATE_RANGE" | cut -d '-' -f 2 | cut -c1-4)
elif [[ ${#DATE_RANGE} -gt 4 ]]; then
  # Single date provided

  if [[ "${DATE_RANGE:((4)):1}" == "-" ]]; then
    echo "Formatted with year first"
    echo "${DATE_RANGE}: ${#DATE_RANGE}"
    YEAR=$(echo "$DATE_RANGE" | cut -c1-4)
  else
    echo "Formatted with year last"
    echo "${DATE_RANGE}: ${#DATE_RANGE}"
    YEAR=$(echo "$DATE_RANGE" | cut -c7-10)
  fi

else
  # Year provided only
  YEAR=$DATE_RANGE

fi


# Form new paper name
if [ "$N_AUTHORS" -eq "1" ]; then

    # 1 author
    AUTHOR_STR=$AUTHOR1

elif [ "$N_AUTHORS" -eq "2" ]; then

    # 2 authors
    AUTHOR2=$(echo "$AUTHORS" |head -n 2 | tr '\n' '_')
    AUTHOR_STR="${AUTHOR1}_${AUTHOR2}"

else
    # More than 2 authors
    AUTHOR_STR="${AUTHOR1}_etal"

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
rm "$BIB"

echo "Done."
