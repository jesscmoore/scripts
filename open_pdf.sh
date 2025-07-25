#!/bin/bash
#
# Time-stamp: <Saturday 2025-07-26 07:11:36 Jess Moore>
#
# Opens the selected pdf file with lightweight pdf reader Skim
#
# Usage: open_pdf.sh [file]

function usage() {
    echo "Usage: open_pdf [file]"
    echo ""
    echo "Description: Opens the selected pdf file with lightweight pdf reader Skim."
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

open "skim://${FILEPATH}"
echo "Opening ${FILE} with Skim..."


## 20250726 Rectangle options
## https://github.com/rxhanson/Rectangle?tab=readme-ov-file
# Also tried setting position with demo.applescript but get repeated 100006 error
open -g "rectangle://execute-action?name=last-three-fourths"
echo "Resizing to left half"

open -g "rectangle://execute-action?name=next-display"
echo "Moving to next display where available"
