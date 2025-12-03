#!/bin/bash
#
# Prints timestamp + author line, eg.
#
# Time-stamp: <Monday 2025-08-04 20:30:26 Jess Moore>
#
# Copyright (C) 2023-2025, Software Innovation Institute, ANU.
#
# Licensed under the GNU General Public License, Version 3 (the "License").
#
# License: https://www.gnu.org/licenses/gpl-3.0.en.html
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.

function usage() {
    echo "Usage: timestamp.sh"
    echo ""
    echo "Description: Prints timestamp + author line to insert in"
    echo "header of file."
    echo ""
    echo "Arguments:"
    echo "  -t type:  Script type eg. bash, dart, py."
    echo "            (Default: bash)."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

NAME=$(id -F)
NOW=$(date "+%A %Y-%m-%d %H:%M:%S")

# Parse arguments and flags
while getopts :h:t: opt; do
    case $opt in
        h) usage;;
        t) TYPE="$OPTARG";;
        :) echo "Missing argument for option -$OPTARG"; exit 1;;
       \?) echo "Unknown option -$OPTARG"; exit 1;;
    esac
done

# Shift positional parameters to remove processed options
shift $(( OPTIND - 1 ))

if [[ $# -eq 0 ]]; then
    TYPE='bash'
fi

# Get script type, define extension and comment string
case "${TYPE}" in
'bash')
    c="#";;
'dart')
    c="//";;
'py')
    c="#";;
*)
    echo "Error: Supported script types are: bash, dart, py";
    exit 1;;
esac



# Add timestamp
# shellcheck disable=SC2129
echo "$c Time-stamp: <${NOW} ${NAME}>"
