#!/bin/bash
#
# Time-stamp: <Monday 2023-04-07 11:48:10 +1000 Jess Moore>
#
# Fix a specific file name or all files in a directory
#
# - replaces " " with "_"
# - replaces " - " with "-"
#
# Usage:
#
# $ fix_file_names
# or
# $ fix_file_names "My Spaced File.docx"

# Filename supplied
if [[ -n "$1"  &&  -e "$1" ]]; then
    f="$1"

    if [[ -n $f ]]; then
        # Replace " " with "_"
        g="${f// /_}"
        mv "$f" "$g"
        echo "replaced ' ' with '_'"

        # Replace " - " with "-"
        i=$(echo "$g" | tr '_-_' '-' | tr -s '-')
        mv "$g" "$i"
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

fi
