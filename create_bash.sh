#!/bin/bash
#
# Time-stamp: <Monday 2023-04-07 11:48:10 +1000 Jess Moore>
#
# Creates bash file with timestamp, name and brief description
#
# Usage: create_bash.sh new_script.sh "Does xyz"

function usage() {
    echo "Usage: $(basename "$0") 'file' 'desc'"
    echo ""
    echo "Description: This script creates a bash script "
    echo "             with name [file].sh and standard format "
    echo "             including datetime author attribution "
    echo "             stamp, usage line, the user provided"
    echo "             one line description of what the script"
    echo "             does. "
    echo ""
    echo "Arguments:"
    echo "  file:      Name of script (excluding .sh)."
    echo "  desc:      One line description of script."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

NAME=$(id -F)
NOW=$(date "+%A %Y-%m-%d %H:%M:%S")
FILEBASE=$1
DESC=$2

FILENAME=$FILEBASE.sh

cat > "${FILENAME}" << EOF
#!/bin/bash
#
# Time-stamp: ${NOW} ${NAME}
#
# ${DESC}
#
# Usage: ${FILENAME} [args...]

function usage() {
    echo "Usage: ${FILENAME} [args...]"
    echo ""
    echo "Description: ${DESC}."
    echo ""
    echo "Arguments:"
    echo "  arg1:      ..."
    echo "  arg2:      ..."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ \$# -eq 0 || \$* == *"help"* || \$* == *"-h"* ]]; then
    usage
fi
EOF
