#!/bin/bash
#
# Time-stamp: <Friday 2025-07-25 21:12:02 Jess Moore>
#
# Files academic paper by moving it to a particular
# research field folder.
#
# Usage: bash file_paper.sh "file" "research_field"

function usage() {
    echo "Usage: $(basename "$0") 'file' 'research_field"
    echo ""
    echo "Description: This script moves a paper to the appropriate "
    echo "folder for papers in that research field."
    echo ""
    echo "Arguments:"
    echo "  file:             Academic paper filename."
    echo "  research_field:   Research category."
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

# Check valid field name
case "${FIELD}" in
'biod')
    FOLDER='biodiversity';;
'kgraph')
    FOLDER='know_graphs';;
'web')
    FOLDER='semantic_web';;
'solid')
    FOLDER=$FIELD;;
*)
    echo "Error: Research field not in field list: ";
    exit 1;;
esac

DIR="${HOME}/Documents/research/${FOLDER}/papers"

# Check destination folder exists
if [ ! -d "$DIR" ]; then
  echo "Error: Destination folder ${DIR} does not exist."
  exit 1
fi

# Move file
NEW_FILE="${DIR}/${FILE}"
mv "$FILE" "${DIR}/."

echo "Successfully moved paper ${FILE}"
ls -l "${NEW_FILE}"

echo "Done."
