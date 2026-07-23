#!/usr/bin/env bash
#
# Time-stamp: <Wednesday 2025-01-22 19:50:02 Jess Moore>
#
# Create a private github repo from current directory
#
# Usage:
# mkdir repo_name
# cd repo_name
# bash create_repo.sh here [org]

function usage() {
    echo "Usage: $(basename "$0") here [org]"
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
    echo "  org:    Optional organisation name to create the repo"
    echo "          under instead of your personal account. You"
    echo "          must be a member of the org with rights to"
    echo "          create repos there."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $# -gt 2 || $* == *"help "* || $* == *"-h"* ]]; then
    usage
fi


PRIVACY=private
DIR="."
ORG="$2"

REPO_NAME=$(basename "$(pwd)")
echo "Current directory: ${REPO_NAME}"

LIST_OWNER=()
if [[ -n "${ORG}" ]]; then
    REPO_FULL_NAME="${ORG}/${REPO_NAME}"
    LIST_OWNER=("${ORG}")
else
    REPO_FULL_NAME="${REPO_NAME}"
fi

echo "Proposed repo name: ${REPO_FULL_NAME}"

if gh repo list "${LIST_OWNER[@]}" | awk '{print $1}' | grep "${REPO_FULL_NAME}"; then
    echo "A repo named ${REPO_FULL_NAME} already exists.";
else

    # TODO: touch README if README.md not found

    git init
    gh repo create "${REPO_FULL_NAME}" --${PRIVACY} \
                                --source="${DIR}" \
                                --remote=upstream;
    echo "Created repo named ${REPO_FULL_NAME}.";
    gh repo list "${LIST_OWNER[@]}" | grep "${REPO_NAME}";
fi
