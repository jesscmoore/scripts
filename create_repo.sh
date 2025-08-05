#!/usr/bin/env bash
#
# Time-stamp: <Wednesday 2025-01-22 19:50:02 Jess Moore>
#
# Create a private github repo from current directory
#
# Usage:
# mkdir repo_name
# cd repo_name
# bash create_repo.sh here

function usage() {
    echo "Usage: $(basename "$0") here"
    echo ""
    echo "Description: This script creates a new github repo"
    echo "          using the parent folder name as the name of the "
    echo "          new repository. It expects the user to have 'cd' "
    echo "          into the project before running "
    echo "          'create_repo here'."
    echo ""
    echo "Arguments:"
    echo "  here:   Required from the user to confirm the"
    echo "          repo location."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi


PRIVACY=private
DIR="."

REPO_NAME=$(basename "$(pwd)")
echo "Current directory: ${REPO_NAME}"

if gh repo list | awk '{print $1}' | grep "${REPO_NAME}"; then
    echo "A repo named ${REPO_NAME} already exists.";
else

    # TODO: touch README if README.md not found

    git init
    gh repo create "${REPO_NAME}" --${PRIVACY} \
                                --source=${DIR} \
                                --remote=upstream;
    echo "Created repo named ${REPO_NAME}.";
    gh repo list | grep "${REPO_NAME}";
fi
