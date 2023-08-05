#!/usr/bin/env bash

URL="https://solid.example.com/" # EDIT ME!
PORT=3000
BASE="/opt/solid"
LOG="${BASE}/log/solid.log"
DATA="${BASE}/server/"

export NVM_DIR="${BASE}/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

case "${1}" in
    start|run)
        if pgrep -f community-solid-server; then
            echo "Server is currently running.";
        else community-solid-server --baseUrl ${URL} --port ${PORT} \
                                    --config @css:config/file-no-setup.json \
                                    --rootFilePath ${DATA} >> ${LOG} 2>&1 & disown;
             pgrep -f community-solid-server; fi;;
    status|check)
        if pgrep -f community-solid-server; then
            echo "Server is currently running.";
        else echo "Server is not running"; fi;;
    see|log)
        cat ${LOG};;
    stop|kill)
        if pgrep -f community-solid-server; then
            pgrep -f community-solid-server | xargs kill
        else echo "Server is not running"; fi;;
    *)
        echo "Supported commands: start, stop, status, log.";;
esac;
