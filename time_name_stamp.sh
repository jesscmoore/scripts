#!/bin/bash
#
# Time-stamp: <Saturday 2025-07-26 06:46:46 Jess Moore>
#
# Get date time stamp with name for attributions.
#
# Usage: time_name_stamp.sh

function usage() {
    echo "Usage: $(basename "$0")"
    echo ""
    echo "Description: This script prints a date time stamp line"
    echo "in the format used in the header of code files."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

# Print usage
if [[ $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

NAME=$(id -F)
NOW=$(date "+%A %Y-%m-%d %H:%M:%S")

echo "Time-stamp: ${NOW} ${NAME}"
