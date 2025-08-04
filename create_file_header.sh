#!/bin/bash
#
# Prints author, copyright and license info to insert in header of file
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
    echo "Usage: create_file_header.sh [-t type] [-d desc]"
    echo ""
    echo "Description: Prints author, copyright and license info to insert in"
    echo "header of file. Inserts a description at top (below slash bang), if "
    echo "description provided."
    echo ""
    echo "Arguments:"
    echo "  -d desc:  Optional file or package description. (No default)."
    echo "  -t type:  Script type (bash, dart, py)"
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

NAME=$(id -F)
NOW=$(date "+%A %Y-%m-%d %H:%M:%S")
YEAR=$(date "+%Y")
RIGHTS_HOLDER=$NAME
LICENSE="GPLV3"

# Use this tmp header file
FILEBASE=tmp_header

# By default, is_shell is false
is_shell=false

# Parse arguments and flags
while getopts :hd:t: opt; do
    case $opt in
        h) usage;;
        d) DESC="$OPTARG";;
        t) TYPE="$OPTARG";;
        :) echo "Missing argument for option -$OPTARG"; exit 1;;
       \?) echo "Unknown option -$OPTARG"; exit 1;;
    esac
done

# Shift positional parameters to remove processed options
shift $(( OPTIND - 1 ))

# Get script type, define extension and comment string
case "${TYPE}" in
'bash')
    is_shell=true;
    SLASHBANG="#!/bin/bash";
    ext="sh";
    c="#";;
'dart')
    ext="dart";
    c="//";;
'py')
    ext='py';
    c="#";;
*)
    echo "Error: Supported script types are: bash, dart, py";
    exit 1;;
esac

# Set temp filename
FILENAME=$FILEBASE.$ext


# Create header file
if [[ -e $FILENAME ]]; then
    rm $FILENAME
fi
touch $FILENAME

# Add slash bang if shell
if $is_shell; then
    printf "%s\n#\n" "$SLASHBANG" >> $FILENAME
fi

# Add description if provided
if [[ -n "$DESC" ]]; then
    printf "%s %s\n%s\n" "$c" "$DESC" "$c" >> $FILENAME
fi

# Add timestamp
# shellcheck disable=SC2129
cat >> "${FILENAME}" << EOF
$c Time-stamp: <${NOW} ${NAME}>
$c
EOF

# Add copyright statement
cat >> "${FILENAME}" << EEOF
$c Copyright (C) $YEAR, $RIGHTS_HOLDER.
$c
EEOF


# Add license statement
if [[ $LICENSE == "GPLV3" ]]; then
cat >> "${FILENAME}" << EEEOF
$c Licensed under the GNU General Public License, Version 3 (the "License").
$c
$c License: https://www.gnu.org/licenses/gpl-3.0.en.html
$c
$c This program is free software: you can redistribute it and/or modify it under
$c the terms of the GNU General Public License as published by the Free Software
$c Foundation, either version 3 of the License, or (at your option) any later
$c version.
$c
$c This program is distributed in the hope that it will be useful, but WITHOUT
$c ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
$c FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
$c details.
$c
$c You should have received a copy of the GNU General Public License along with
$c this program.  If not, see <https://www.gnu.org/licenses/>.
$c
EEEOF
fi

# Add author
cat >> "${FILENAME}" << EEEEOF
$c Authors: $NAME
EEEEOF

# Print to stdout
cat $FILENAME
rm $FILENAME
