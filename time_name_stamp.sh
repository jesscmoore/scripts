#!/bin/bash
#
# Time-stamp: <Saturday 2025-07-26 06:46:46 Jess Moore>
#
# Get date time stamp with name for attributions.
#
# Usage: time_name_stamp.sh

function usage() {
    echo "Usage: $(basename "$0") 'file' 'desc'"
    echo ""
    echo "Description: This script creates a bash script "
    echo "             with name [file].sh and standard format "
    echo "             including datetime author attribution "
    echo "             stamp, usage line, the user provided"
    echo "             one line description of what the script"
    echo "             does. "
    echo ""
    echo "Arguments:"
    echo "  file:      Name of script (excluding .sh)."
    echo "  desc:      One line description of script."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

# Print usage
if [[ $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

NAME=$(id -F)
NOW=$(date "+%A %Y-%m-%d %H:%M:%S")

echo "Time-stamp: <${NOW} ${NAME}>"
