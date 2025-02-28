#!/bin/bash
#
# Time-stamp: <Friday 2024-03-10 21:29:02 Jess Moore>
#
# Create a jekyll website blog post markdown file
# with some template text
#
# Usage: bash create_post.sh install-openhab "How to install OpenHAB"

NAME=`id -F`

# Datetime of now in jekyll blog post format
NOW=`date "+%Y-%m-%d %H:%M:%S %z"`

# Abbreviated title
FILEPARTNAME=$1
# Blog post title
TITLE=$2
# Date for post filename
NOW_DATE_ONLY=`date "+%Y-%m-%d"`

FILENAME=${NOW_DATE_ONLY}-${FILEPARTNAME}.md

cat > ${FILENAME} << EOF
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
