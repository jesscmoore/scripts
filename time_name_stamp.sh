#!/bin/bash
#
# Time-stamp: <Saturday 2025-07-26 06:46:46 Jess Moore>
#
# Get date time stamp with name for attributions.
#
# Usage: time_name_stamp.sh

NAME=$(id -F)
NOW=$(date "+%A %Y-%m-%d %H:%M:%S")

echo "Time-stamp: <${NOW} ${NAME}>"
