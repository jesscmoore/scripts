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
SCRIPT_DIR="${HOME}/Documents/scripts"
BIN_DIR="${HOME}/bin"

echo "Script file: ${SCRIPT_DIR}/${SCRIPT_FILE}"
echo "Command to be created ${COMMAND}"

chmod u+x ${SCRIPT_DIR}/${SCRIPT_FILE}
ln -s ${SCRIPT_DIR}/${SCRIPT_FILE} ${BIN_DIR}/${COMMAND}
echo "Created ${COMMAND}"
ls -l ${HOME}/bin/${COMMAND}
