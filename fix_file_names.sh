#!/bin/bash
#
# Time-stamp: <Monday 2023-04-07 11:48:10 +1000 Jess Moore>
#
# Fix filenames
# - replaces " " with "_"
# - replaces " - " with "-"

# Replace " " with "_"
for f in *\ *; do 
    if [[ -n $f ]]; then
        mv "$f" "${f// /_}"
    fi
done

# Replace " - " with "-"
for g in *_-_*; do 
    if [[ -n $g ]]; then
        i=`echo $g | tr '_-_' '-' | tr -s '-'`
        mv "$g" "$i"
    fi
done


