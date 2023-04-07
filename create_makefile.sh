#!/bin/bash
#
# Time-stamp: <Friday 2023-04-07 19:44:36 Jess Moore>
#
# Create a makefile
# 
# Usage: create_makefile.sh Makefile

NAME=`id -F`
NOW=`date "+%A %Y-%m-%d %H:%M:%S"`
FILENAME=$1

cat > ${FILENAME} << EOF
# Time-stamp: <${NOW} ${NAME}>
#
EOF
