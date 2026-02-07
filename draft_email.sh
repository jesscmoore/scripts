#!/bin/bash
#
# Time-stamp: <Monday 2025-08-18 13:05:58 Jess Moore>
#
# Create a draft of an email in markdown
#
# Usage: draft_email.sh [args...]

function usage() {
    echo "Usage: draft_email recipient"
    echo ""
    echo "Description: Create a draft of an email in markdown."
    echo ""
    echo "Arguments:"
    echo "  recipient:  Name of recipient"
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

RECIPIENT=$1
SENDER=$(id -F)
NOW=$(date "+%A %Y-%m-%d %H:%M:%S")

## Form filename with syntax YYmmdd-draftEmailTo-person.md
# Convert recipient to lower Camel Case
PEOPLE_SUMM=$(echo "$RECIPIENT" | awk '{print tolower($0);}' | awk '{print $1, toupper(substr($2,1,1)) substr($2,2)}' | sed 's/ //g')

SENDER_FIRSTNAME=$(echo "$SENDER" | awk '{print $1}')

DATE_SUMM=$(date "+%Y%m%d")
# Form filename
FILENAME="${DATE_SUMM}-draftEmailTo-${PEOPLE_SUMM}.md"


cat > "${FILENAME}" << EOF
*From: ${SENDER}*

*To: ${RECIPIENT}*

**Subject: [ADD]**

*Date: ${NOW} ${SENDER}*

Hi [ADD]





Regards,
${SENDER_FIRSTNAME}

[ADD SIGNATURE]





<!-- markdownlint-disable-file MD009 MD012 MD013 MD029 MD036 MD041 -->
<!-- Ignores line length limit, no trailing spaces, multiple blanks, etc -->
EOF

echo "Done"
echo "Output: "
ls -l "$FILENAME"
