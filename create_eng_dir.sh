#!/bin/bash
#
# Time-stamp: <Friday 2025-07-25 11:22:02 Jess Moore>
#
# Creates a folder for a new potential project engagement
#
# Usage: bash create_eng_dir.sh "orgPartner1, orgPartner2"

function usage() {
    echo "Usage: $(basename "$0") 'partners'"
    echo ""
    echo "Description: This script creates a folder in the "
    echo "             current directory for a new project"
    echo "             engagement. Fields: partners, which is"
    echo "             a comma separated list of organisational"
    echo "             partners."
    echo ""
    echo "Arguments:"
    echo "  partners:  Comma separated organisational partners "
    echo "             surrounded in quotes."

    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 ]]; then
    usage
fi

MYORG=SII
YEARMON=$(date "+%Y-%m")
PARTNERS=$1

## Form filename with syntax YYmmdd-person1_person2_author.md
# Convert partners to uc, replace ", " with "-"
PARTNER_SUMM=$(echo "$PARTNERS" | awk '{print toupper($0);}' | sed 's/,/ /g;s/  / /g;s/ /-/g')
# Get lowercase firstname of author
DIR="${YEARMON}-${PARTNER_SUMM}-${MYORG}"

mkdir "$DIR"
echo "Created folder $DIR"
ls -aFl "$DIR"
