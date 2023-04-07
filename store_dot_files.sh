#!/bin/bash
#
# Time-stamp: <Friday 2023-04-07 15:27:12 Jess Moore>
#
# Syncs dot files to ~/Documents/scripts/home

SCRIPTS=${HOME}/Documents/scripts

rsync -avh --files-from=${SCRIPTS}/etc/inclusions \
    ${HOME}/ ${SCRIPTS}/home/.


