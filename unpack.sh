#!/bin/bash
#
# Time-stamp: Sunday 2026-01-25 17:00:39 Jess Moore
#
# Uncompress zip file, move to dir, and prefix each file
#
# Usage: unpack.sh [args...]

function usage() {
    echo "Usage: unpack.sh zip_file path_to_dir prefix"
    echo ""
    echo "Description: Uncompress zip file, move to dir, and prefix each file."
    echo ""
    echo "Arguments:"
    echo "  zip_file:    Zip file to uncompress."
    echo "  path_to_dir: Path of destination directory."
    echo "  prefix:      Optional string to prepend to extracted files."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -lt 2 || $* == *"help"* || $* == *"-h"* || $# -gt 3 ]]; then
    usage
fi

ZIPFILE=$1
FOLDER=$2

if [[ $# -eq 3  ]]; then
    PREF=$3
    DESTPATH="$FOLDER/$PREF-"
else 
    DESTPATH="$FOLDER/"
fi

echo "Unpacking:"
echo "File: $ZIPFILE"
echo "Destination path: $FOLDER ..."  
echo "Destination files: $DESTPATH ..."


# Check zip file exists
if [ ! -f "$ZIPFILE" ]; then
  echo "Error: ${ZIPFILE} does not exist. Check filename is correct."
  exit 1
fi

# Make target directory if it doesn't exist
mkdir -p "$FOLDER"

# Create a unique temporary directory for extraction
# mktemp ensures a unique directory name
TEMPDIR=$(mktemp -d)

# 3. Unzip the file to the temporary directory
unzip -q "$ZIPFILE" -d "$TEMPDIR"

# Move extracted files and rename as required
for extracted_file in "$TEMPDIR"/*; do
    
    # Existing filename
    filename=$(basename "$extracted_file")
    
    # Move and rename the file with the new prefix to the target directory
    mv "$extracted_file" "$DESTPATH$filename"
    
done

# Remove the temporary directory
rmdir "$TEMPDIR"

ls -ll "$DESTPATH"
echo "Done."
