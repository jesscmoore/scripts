#!/bin/bash
#
# Time-stamp: Thursday 2025-09-25 13:46:05 Jess Moore
#
# Write a git tag of a file
#
# Usage: create_git_tag.sh [args...]

function usage() {
    echo "Usage: create_git_tag.sh [tag_num] [comment]"
    echo ""
    echo "Description: Write a git tag of a file."
    echo ""
    echo "Arguments:"
    echo "  tag_num:    Tag version number. (Default: none)."
    echo "  comment:    Tag comment. (Default: none)."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -ne 2 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

TAG=$1
COMMENT=$2

git tag -a "v${TAG}" -m "${COMMENT}"

echo "Pushing tags"
git push origin --tags

echo ""
echo "More info:"
echo "git show v${TAG}"
echo "git log --pretty=oneline --abbrev-commit"
echo "Done."
