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

PRIVACY=private
DIR="."
REPO_NAME=$(basename `pwd`)

# gh repo create ${REPO_NAME} --${PRIVACY} --source=${DIR} --remote=upstream
echo "Current directory: ${REPO_NAME}"

case "${1}" in
    here)
        if gh repo list | awk '{print $1}' | grep ${REPO_NAME}; then
            echo "A repo named ${REPO_NAME} already exists.";
        else
            git init
            gh repo create ${REPO_NAME} --${PRIVACY} \
                                        --source=${DIR} \
                                        --remote=upstream;
            echo "Created repo named ${REPO_NAME}.";
            gh repo list | grep ${REPO_NAME};
        fi;;
    *)
        echo "Supported commands: here";;
esac;
