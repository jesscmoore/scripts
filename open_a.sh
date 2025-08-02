#!/bin/bash
#
# Time-stamp: <Sunday 2025-08-03 05:11:36 Jess Moore>
#
# A shorthand method to open the selected file with my
# preferred app.
#
# Usage: open_a.sh [file]

function usage() {
    echo "Usage: open_a [file]"
    echo ""
    echo "Description: Opens the selected file with my preferred app."
    echo ""
    echo "Arguments:"
    echo "  file:      The selected pdf file to open."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

FILE=$1
DIR=$(pwd)
FILEPATH="${DIR}/${FILE}"

# Get file type
EXT="${FILE##*.}"

case "${EXT}" in
'pdf')
    APP=skim;
    open "${APP}://${FILEPATH}";;

'xlsx'|'xls')
    APP=/Applications/Microsoft\ Excel.app;;

'docx'|'doc')
    APP=/Applications/Microsoft\ Word.app;;

*)
    echo "Error: ${FILE} is not in a supported file format.";
    exit 1;;
esac

APPS=('xlsx' 'xls' 'docx' 'doc')

if [[ ${APPS[*]} == *"${EXT}"* ]]; then
    open -a "${APP}" "${FILE}"
fi


echo "Opening ${FILE} with ${APP}..."


## 20250726 Rectangle options
## https://github.com/rxhanson/Rectangle?tab=readme-ov-file
# Also tried setting position with demo.applescript but get repeated 100006 error
open -g "rectangle://execute-action?name=last-three-fourths"
echo "Resizing to last three fourths of display"

open -g "rectangle://execute-action?name=next-display"
echo "Moving to next display where available"
