#!/bin/bash

# Monitor the existance and running of the kdetmofsi malware.

while true; do
    printf "$(date) $(uptime)\n" >> kdevtmpfsi.log;
    find / -name 'kdevtmpfsi' >> kdevtmpfsi.log;
    ps uaxxc | grep kdevtmpfsi >> kdevtmpfsi.log
    sleep 5m; done
