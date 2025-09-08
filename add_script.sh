#!/usr/bin/env bash
#
# Time-stamp: <Wednesday 2025-01-22 21:40:10 Jess Moore>
#
# Make script executable and add to ${HOME}/bin
#
# Usage:
# bash add_script.sh [script_name]
# where [script_name] is the name of the script without the suffix .sh

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
