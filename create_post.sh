#!/bin/bash
#
# Time-stamp: <Friday 2024-03-10 21:29:02 Jess Moore>
#
# Create a jekyll website blog post markdown file
# with some template text
#
# Usage: bash create_post.sh install-openhab "How to install OpenHAB"

function usage() {
    echo "Usage: $(basename "$0") 'title' 'attendee1, attendee2' 'place'"
    echo ""
    echo "Description: This script creates a Jekyl post file"
    echo "             in markdown format with fields: filepart "
    echo "             and title. Posts are not published until "
    echo "             post YAML is changed to 'published: true'"
    echo "             and content built and pushed to web server."
    echo ""
    echo "Arguments:"
    echo "  title:     Blog post title."
    echo "  filepart:  The text component of the filename. "
    echo "             Used to construct filename with format"
    echo "             YYYYMMDD-file-part.md."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

# Datetime of now in jekyll blog post format
NOW=$(date "+%Y-%m-%d %H:%M:%S %z")

# Abbreviated title
FILEPARTNAME=$1
# Blog post title
TITLE=$2
# Date for post filename
NOW_DATE_ONLY=$(date "+%Y-%m-%d")

FILENAME=${NOW_DATE_ONLY}-${FILEPARTNAME}.md

cat > "${FILENAME}" << EOF
---
layout: post
title:  "${TITLE}"
date:   ${NOW}
published: false
toc: true
---

Short 1-2 sentence introduction.

**Summary**

1. [command] - 1 line explanation
2. [command] - 1 line explanation

## Procedure

### Sub heading 1

Text.

See [other post]({% post_url 2021-03-02-how-to-setup-jekyll %}) for how to do xyz.

[command block]


### Sub heading 2

Text.

[command block]

**References**

- [url1]
- [url2]
EOF

echo "Successfully created post ${FILENAME} with template text."
