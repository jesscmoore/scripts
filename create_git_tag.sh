#!/bin/bash
#
# Time-stamp: Thursday 2025-09-25 13:46:05 Jess Moore
#
# Write a git tag of a file
#
# Usage: create_git_tag.sh [args...]

function usage() {
    echo "Usage: create_git_tag.sh [tag_num] [comment] [file]"
    echo ""
    echo "Description: Write a git tag of a file."
    echo ""
    echo "Arguments:"
    echo "  tag_num:    Tag string. Eg. 'v0.4-toCPA-20260226'"
    echo "  comment:    Tag comment. (Default: none)."
    echo "  file:       Optional filename to append tag to and copy "
    echo "              to shared_and_tagged/ folder"
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -lt 2 || $# -gt 3  || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

TAG=$1
COMMENT=$2
if [[ $# -eq 3 ]]; then 
    FILE=$3
fi

git tag -a "${TAG}" -m "${COMMENT}"

echo "Pushing tags"
git push --tags

echo ""
echo "More info:"
echo "git show ${TAG}"
echo "git log --pretty=oneline --abbrev-commit"

if [[ $# -eq 3 ]]; then 
    EXT="${FILE##*.}"
    BASENAME="${FILE%.*}"
    mkdir -p shared_and_tagged
    cp -p "${FILE}" "shared_and_tagged/${BASENAME}-${TAG}.${EXT}"
    ls -lt shared_and_tagged
fi

echo "Done."
