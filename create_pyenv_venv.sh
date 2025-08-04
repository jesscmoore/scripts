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
    echo "  env_name: Name of project virtual environment."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

PYVER="$1"
ENVNAME="$2"

pyenv install "${PYVER}"

# Create virtual environment
pyenv virtualenv "${PYVER}" "${ENVNAME}"

# Check environment created
pyenv virtualenvs

#
pyenv local markit
pyenv activate "${PYVER}/envs/${ENVNAME}"
