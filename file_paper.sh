#!/bin/bash
#
# Time-stamp: <Friday 2025-07-25 21:12:02 Jess Moore>
#
# Files academic paper by moving it to a particular
# research field folder.
#
# Usage: bash file_paper.sh "file" "research_field"

declare -a FIELDS
declare -a FOLDERS
FIELDS=('biod' 'kgraph' 'web' 'solid' 'dis' 'indig' 'privacy')
FOLDERS=('biodiversity' 'know_graphs' 'semantic_web' 'solid' 'disaster' 'indigenous' 'privacy')

function usage() {
    echo "Usage: $(basename "$0") 'file' 'research_field"
    echo ""
    echo "Description: This script moves a paper to the appropriate "
    echo "folder for papers in that research field."
    echo ""
    echo "Arguments:"
    echo "  file:             Academic paper filename."
    printf -v joined_fields '%s, ' "${FIELDS[@]}"
    echo "  research_field:   Research field category (${joined_fields})"
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 ]]; then
    usage
fi

FILE=$1
FIELD=$2


# Check paper exists
if [ ! -f "$FILE" ]; then
  echo "Error: Paper ${FILE} does not exist. Check filename is correct."
  exit 1
fi

for i in $(seq 0 ${#FIELDS[@]});
do
    echo "Checking ${FIELD} == ${FIELDS[i]}..."
    if [ "${FIELDS[i]}" == "${FIELD}" ]; then
        FOLDER="${FOLDERS[i]}";
        break;
    elif [[ $i -eq "${#FIELDS[@]}-1" ]]; then
        echo "Error: Research field not in field list.";
        exit 1;
    fi
done

DIR="${HOME}/Documents/research/${FOLDER}/papers"
mkdir -p "${DIR}"

# Move file
NEW_FILE="${DIR}/${FILE}"
mv "$FILE" "${DIR}/."

echo "Successfully moved paper ${FILE}"
ls -l "${NEW_FILE}"

echo "Done."
