#!/bin/bash
#
# Time-stamp: <Friday 2025-07-22 15:12:32 Jess Moore>
#
# Create a makefile
#
# Usage: create_makefile.sh

NAME=`id -F`
NOW=`date "+%A %Y-%m-%d %H:%M:%S"`
FILENAME=$1

cat > ${FILENAME} << EOF
# Time-stamp: <${NOW} ${NAME}>
#
SHELL=/bin/bash

########################################################################
# HELP
#
# Help for targets defined in this Makefile.

define HELP

	targetA     1 line description of targetA

endef
export HELP

help::
	@echo "$$HELP"

########################################################################
# Add make target rules here
EOF
