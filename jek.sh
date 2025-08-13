#!/bin/bash
#
# Time-stamp: <Wednesday 2025-08-13 20:13:25 Jess Moore>
#
# Shorthand for building and serving jekyll site
#
# Usage: jek.sh [args...]

function usage() {
    echo "Usage: jek.sh [-u] [arg]"
    echo ""
    echo "Description: Shorthand for building and serving jekyll site."
    echo ""
    echo "Arguments:"
    echo "  build:  Build jekyll site"
    echo "  serve:  Serve jekyll site locally."
    echo ""
    echo "Flags:"
    echo "  -u:     Show unpublished pages. (Default: false)."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

JCMD="bundle exec jekyll"

# By default, show_unpub is false
show_unpub=false

# Parse arguments and flags
while getopts :hu opt; do
    case $opt in
        h) usage;;
        u) show_unpub=true;;
       \?) echo "Unknown option -$OPTARG"; exit 1;;
    esac
done

# Shift positional parameters to remove processed options
shift $(( OPTIND - 1 ))

# Filename supplied
if [[ -n "$1" ]]; then
    CMD="$1"
fi

case "${CMD}" in
'build')
    echo "Building site...";;
'serve')
    echo "Serving site locally...";;
*)
    echo "Error ${CMD} is not in a supported jekyll command.";
    usage;;
esac

if $show_unpub; then
    echo "Including unpublished pages"
    ${JCMD} "${CMD}" "--unpublished"
else
    echo "Published pages only"
    ${JCMD} "${CMD}"
fi

echo "Done."
