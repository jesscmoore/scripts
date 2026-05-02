#!/bin/bash
#
# Time-stamp: Saturday 2026-05-02 19:12:25 Jess Moore
#
# Stops Google FinderHelper which blocks Nextcloud client
# This script stops Google FinderHelper. This is necessary to 
# allow Nextcloud macos client to open and stay open on MacOS
#
# This script is run at login using login launch agent at
#  ~/Library/LaunchAgents/com.user.help_nextcloud_sync.plist
# which calls bash to run this script
# Script loaded with
#
# launchctl load ~/Library/LaunchAgents/com.user.help_nextcloud_sync.plist
# 
# Test: restart computer, nextcloud menu icon and syncing should stay open and 
# Google FinderHelper should stay off
#
# To confirm whether Google's FinderHelper is open:
# Open Settings > Login & Extensions
# Scroll to Extensions > click Categories 
# Click info icon on FileProviders
# FinderHelper fileprovider should be off
# If not, turn off (or run this script) and restart Nextcloud
# The green sync icon status on Nextcloud resources should 
# return in the Nextcloud folder within Finder app
#
# Usage: help_nextcloud_sync.sh [args...]

function usage() {
    echo "Usage: help_nextcloud_sync.sh [args...]"
    echo ""
    echo "Description: Stops Google FinderHelper which blocks Nextcloud client."
    echo ""
    echo "Arguments:"
    echo "  arg1:      ..."
    echo "  arg2:      ..."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $* == *"help "* || $* == *"-h"* ]]; then
    usage
fi


pluginkit -e ignore -i com.google.drivefs.finderhelper.findersync   
