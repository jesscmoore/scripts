#!/bin/bash
#
# Time-stamp: Sunday 2026-02-08 15:08:16 Jess Moore
#
# Export markdown file in standard format (eg. pdf) for sharing with others
#
# Usage: export_it.sh [args...]

function usage() {
    echo "Usage: export_it.sh [file] [output_format]"
    echo ""
    echo "Description: Export markdown file in standard format (eg. pdf) for sharing with others."
    echo ""
    echo "Arguments:"
    echo "- file:           Name of markdown file to export"
    echo "- output_format:  Export format of output file (default: pdf)"
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $# -gt 2 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

INFILE=$1

# Set format
FORMAT="pdf"
if [[ $# -eq 2 ]]; then 
    FORMAT=$2
fi

# Set margin
MARGIN="2cm"


# Set output filename
filename=$(basename -- "$INFILE")
filename="${filename%.*}"
OUTFILE="${filename}.${FORMAT}"

# Export file to desired format
echo "Exporting to ${FORMAT}..."
pandoc "${INFILE}" -o "${OUTFILE}" -V geometry:margin="${MARGIN}"

ls -l "${OUTFILE}"
echo "Done."
