#!/usr/bin/env bash
#
# Time-stamp: <Wednesday 2025-01-22 21:40:10 Jess Moore>
#
# Make script executable and add to ${HOME}/bin
#

function usage() {
    echo "Usage: $(basename "$0") 'file'"
    echo ""
    echo "Description: This script makes the target script with name"
    echo "             [file].sh executable and copies it to "
    echo "             ~/bin where it is accessible in the PATH."
    echo ""
    echo "Arguments:"
    echo "  file:      Name of script (excluding .sh)."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

SCRIPT_FILE=${1}.sh
COMMAND=${1}
SCRIPT_DIR=$(pwd)
SCRIPT_PATH="${SCRIPT_DIR}/${SCRIPT_FILE}"
BIN_DIR="${HOME}/bin"

echo "Script file: ${SCRIPT_PATH}"
echo "Command to be created ${COMMAND}"

if [[ -f $SCRIPT_PATH ]]; then

    chmod u+x "${SCRIPT_PATH}"
    ln -s "${SCRIPT_PATH}" "${BIN_DIR}"/"${COMMAND}"
    echo "Done: created ${COMMAND}"
    ls -l "${HOME}"/bin/"${COMMAND}"
 else
    echo "Error: missing $SCRIPT_PATH.";
    exit 1;
fi;
