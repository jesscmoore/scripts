#!/bin/bash
#
# Time-stamp: <Monday 2023-04-07 11:48:10 +1000 Jess Moore>
#
# Fix a specific file name or all files in a directory
#
# - replaces " " with "_"
# - replaces " - " with "-"

function usage() {
    echo "Usage: $0 [-d] [file]"
    echo ""
    echo "Description: Converts Windows style filenames with spaces to "
    echo "linux style whitespace free filenames, either for all files in "
    echo "the current directory or a specified file."
    echo ""
    echo "Arguments:"
    echo "  file: Name of file to fix the filename of. (No default)."
    echo ""
    echo "Flags:"
    echo "  -d:   Prepend file with last modified date. (No default)."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

# By default, is_shell is false
show_date=false

# Parse arguments and flags
while getopts :hd opt; do
    case $opt in
        h) usage;;
        d) show_date=true;;
        :) echo "Missing argument for option -$OPTARG"; exit 1;;
       \?) echo "Unknown option -$OPTARG"; exit 1;;
    esac
done

# Shift positional parameters to remove processed options
shift $(( OPTIND - 1 ))


# Filename supplied
if [[ -n "$1"  &&  -e "$1" ]]; then
    f="$1"

    if [[ -n $f ]]; then
        # Replace " " with "_"
        g="${f// /_}"
        if [ "$f" != "$g" ]; then
            mv "$f" "$g"
            echo "Replaced ' ' with '_'"
            f=$g # Update f
        else
            echo "No spaces found in filename."
        fi

        # Replace " - " with "-"
        g="${f//_-_/-}"
        if [ "$f" != "$g" ]; then
            mv "$f" "$g"
            echo "Replaced ' - ' with '-'"
            f=$g # Update f
        else
            echo "No hyphens in spaces found in filename."
        fi

        # Replace "," with ""
        g="${f//,/}"
        if [ "$f" != "$g" ]; then
            mv "$f" "$g"
            echo "Replaced ',' with ''"
            f=$g # Update f
        else
            echo "No commas found in filename."
        fi

        # Replace "+" with ""
        g="${f//+/_}"
        if [ "$f" != "$g" ]; then
            mv "$f" "$g"
            echo "Replaced '+' with '_'"
            f=$g # Update f
        else
            echo "No + found in filename."
        fi

        # Replace "[]" with ""
        g="${f//[][]/}"
        if [ "$f" != "$g" ]; then
            mv "$f" "$g"
            echo "Replaced '[]' with ''"
            f=$g # Update f
        else
            echo "No [] found in filename."
        fi

        # Replace "()" with ""
        # sed better than parameter expansion
        # shellcheck disable=SC2001
        g=$(echo "$f" | sed 's/(\([^)]*\))/\1/g')
        if [ "$f" != "$g" ]; then
            mv "$f" "$g"
            echo "Replaced '()' with ''"
            f=$g # Update f
        else
            echo "No () found in filename."
        fi

        # Prepend with last modified date
        if $show_date; then
            DATE_SUMM=$(stat -f %Sm -t %Y%m%d "$f")
            g="${DATE_SUMM}-$f"
            mv "$f" "$g"
            echo "Prepending file with today's date."
            f=$g
        fi

        # Print recently changed matching files
        # shellcheck disable=SC2012
        ls -l "$f"
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
