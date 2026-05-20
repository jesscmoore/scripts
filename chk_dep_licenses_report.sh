#!/bin/bash
#
# Time-stamp: Sunday 2026-05-03 18:29:06 Jess Moore
#
# Produces a report of all the licenses of a project by analysing dependencies

declare -a SCOPYLEFT
SCOPYLEFT=('GPL-3.0')
FMT='csv'
REPORT=false
# CHK_LICENSE='very_good packages check licenses --dependency-type=direct-main'


function usage() {
    echo "Usage: chk_dep_licenses_report.sh [option]"
    echo ""
    echo "Description: Produces a report of all the licenses of a project by analysing dependencies."
    echo ""
    echo "Options:"
    echo "  -o, --output <fmt>    Set the output format 'text', 'csv' or 'report' (default: ${FMT})."
    echo "  -h, --help             Show this help message."
    echo ""
    exit 0 # Exit with a non-zero status to indicate an error
}

if [[ $* == *"help "* || $* == *"-h"* ]]; then
    usage
fi

# Parse input arguments.

while [[ "$1" != "" ]]; do
    case $1 in
        -o | --output)
            shift
            case $1 in 
                # Allowed output formats
                text|csv)
                    FMT=$1
                    ;;
                report)
                    FMT='csv'
                    REPORT=true
                    ;;
                *)
                    echo "In other (nested)"
                    usage
                    ;;
            esac
            break
            ;;
        -h | --help)
            usage
            ;;
        *)
            usage
            ;;
    esac
done

# Analyses downloaded dependencies (ie. not those
# sourced from path)
# direct dependencies, overridden dependencies
# transitive dependencies

# To ignore path type overrides
# Comment out path type overrides and download
# Use '##' to avoid commenting/uncommenting deliberately commented path type dependencies
# echo "Temporarily commenting out path type dependencies, downloading packages to run license report"
perl -pi -e 's/^    path/    ## path/' pubspec.yaml   
flutter pub get > /dev/null 2>&1
# Perform license check
OUTPUT=$(very_good packages check licenses \
--dependency-type=direct-main,direct-overridden,transitive \
--reporter="$FMT" --no-verbose)
PID=$!
wait $PID
# Restore path type overrides and download
# Use '##' to avoid commenting/uncommenting deliberately commented path type dependencies
# echo "Restoring any path type dependencies, and re-downloading packages\n"
perl -pi -e 's/^    ## path/    path/' pubspec.yaml
flutter pub get > /dev/null 2>&1


# Output without report
if [[ $REPORT == false ]]; then 
    echo "$OUTPUT" | 
    ghead -n -1 # Skip last line showing elapsed time
    exit 0
fi 

# Generate report

# Remove first and last lines
# OUTPUTT=$(sed '1d;$d' "$OUTPUT" | cat)

gen_report() {

    echo "$OUTPUT" | 
    ghead -n -1 | # Skip last line showing elapsed time
    gawk -F',' '
NR==1 { 
    print "# Software Bill of Materials\n"
    print "## Summary\n\n" $0; next 
}
{
    # Count the number of lines with each unique 
    # license in column 2
    col2 = $2
    # Remove leading/trailing whitespace if necessary
    gsub(/^[ \t]+|[ \t]+$/, "", col2)
    count[col2]++
    lines[col2][count[col2]] = $0
}
END {
    # Sort the unique license values
    n = asorti(count, sorted_keys)
    for (i = 1; i <= n; i++) {
        key = sorted_keys[i]
        print "\n## " key "\n" # Print license
        print "*Number: " count[key] "*\n" # Print count of that license
        for (j = 1; j <= count[key]; j++) {
            # Ignore license after comma
            split(lines[key][j], a, ","); print a[1]
        }
    }
}
'
}

gen_report 
