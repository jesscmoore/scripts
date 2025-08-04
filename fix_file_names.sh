#!/bin/bash
#
# Time-stamp: <Monday 2023-04-07 11:48:10 +1000 Jess Moore>
#
# Fix a specific file name or all files in a directory
#
# - replaces " " with "_"
# - replaces " - " with "-"

function usage() {
    echo "Usage: $0 [file]"
    echo ""
    echo "Description: Converts Windows style filenames with spaces to "
    echo "linux style whitespace free filenames, either for all files in "
    echo "the current directory or a specified file."
    echo ""
    echo "Arguments:"
    echo "  file: Name of file to fix the filename of. (No default)."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi


# Filename supplied
if [[ -n "$1"  &&  -e "$1" ]]; then
    f="$1"

    # Get file type
    EXT="${f##*.}"

    # Get file extension
    BASENAME=${f%.*}
    PREF=${BASENAME:0:3}

    if [[ -n $f ]]; then
        # Replace " " with "_"
        g="${f// /_}"
        if [ "$f" != "$g" ]; then
            mv "$f" "$g"
            echo "Replaced ' ' with '_'"
        else
            echo "No spaces found in filename."
        fi

        # Replace " - " with "-"
        i="${g//_-_/-}"
        if [ "$g" != "$i" ]; then
            mv "$g" "$i"
            echo "Replaced ' - ' with '-'"
        else
            echo "No hyphens in spaces found in filename."
        fi

        # Print recently changed matching files
        # shellcheck disable=SC2012
        ls -lt ./"$PREF*.$EXT" | head -n 5
    fi

else
# Run on all files

    # Replace " " with "_"
    for f in *\ *; do
        if [[ -n $f ]]; then
            mv "$f" "${f// /_}"
        fi
    done

    # Replace " - " with "-"
    for g in *_-_*; do
        if [[ -n $g ]]; then
            i=$(echo "$g" | tr '_-_' '-' | tr -s '-')
            mv "$g" "$i"
        fi
    done

    # Print filenames with most recent first
    ls -lt

fi
