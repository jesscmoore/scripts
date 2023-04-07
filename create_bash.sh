#!/bin/bash
#
# Time-stamp: <Monday 2023-04-07 11:48:10 +1000 Jess Moore>
#
# Creates bash file with timestamp, name and brief description 
# 
# Usage: create_bash.sh new_script.sh "Does xyz"

NAME=`id -F`
NOW=`date "+%A %Y-%m-%d %H:%M:%S"`
FILENAME=$1
DESC=$2

cat > ${FILENAME} << EOF
#!/bin/bash
#
# Time-stamp: <${NOW} ${NAME}>
#
# ${DESC}
EOF