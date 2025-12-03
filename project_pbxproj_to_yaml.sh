#!/bin/bash
#
# Time-stamp: Wednesday 2025-12-03 10:52:09 Jess Moore
#
# Convert xcode project.pbxproj to yaml formatted project.yaml.
#
# Usage: project_pbxproj_to_yaml.sh

function usage() {
    echo "Usage: project_pbxproj_to_yaml.sh [path/to/project.pbxproj]"
    echo ""
    echo "Description: Convert xcode project.pbxproj to yaml "
    echo "formatted project.yml."
    echo ""
    echo "Arguments:"
    echo " infile:  Path to input Xcode project.pbxproj file."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# == 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

INFILE=$1
BASENAME=project-converted
OUTFILE_JSON=${BASENAME}.json
OUTFILE_YML=${BASENAME}.yml

echo "Step 1: Converting to json... ${OUTFILE_JSON}"
plutil -convert json -r -o "${OUTFILE_JSON}" -- "${INFILE}"

echo "Step 2: Converting to yaml... ${OUTFILE_YML}"
yq -P "${OUTFILE_JSON}" > "${OUTFILE_YML}"

echo "Done."
ls -lt ${BASENAME}*
