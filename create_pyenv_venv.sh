#!/bin/bash
#
# Time-stamp: <Sunday 2025-08-03 22:16:52 Jess Moore>
#
# Sets up a new python pyenv virtualenv for my project directory

function usage() {
    echo "Usage: $0 py_ver env_name"
    echo ""
    echo "Description: Sets up a new python pyenv virtualenv with "
    echo "name 'env_name' using python version 'py_ver' for "
    echo "my project directory."
    echo ""
    echo "Arguments:"
    echo "  py_ver:   Numeric python version eg 3.13.0"
    echo "  env_name: Name of project virtual environment, where env_name"
    echo "            should match current directory and top level of"  echo "            project."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

if [[ $# -eq 2 ]]; then
    PYVER="$1"
    ENVNAME="$2"
fi

PWD=$(pwd)
CURR_FOLDER=$(basename "$PWD")
if [[ ${CURR_FOLDER != "${ENV_NAME}"} ]]; then
    echo "Expects env_name ${ENV_NAME} to match current working directory and "
    echo "top level of project."
    usage
fi

# Show current versions
installed=$(pyenv versions)
if echo "${installed}" | grep "${PYVER}" >/dev/null; then
    echo "Selected py version already installed"
else
    echo "Selected py version not installed, installing now..."
    pyenv install "${PYVER}"
fi

# Create virtual environment
pyenv virtualenv "${PYVER}" "${ENVNAME}"

# Activate local environment in current directory
pyenv local "${ENVNAME}"

echo "Done."
