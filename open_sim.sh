#!/bin/bash
#
# Time-stamp: <Friday 2025-03-16 11:41:12 Jess Moore>
#
# Opening mobile development simulator.
#
# Usage: bash open_sim.sh

# Package type
case "${1}" in
    ios|android)

        echo "Opening ${1} simulator.";;

    *)
        echo "Supported options: ios, android.";
        exit;;
esac;

TYPE=$1

########################################################################
if [ "${TYPE}" = "ios" ]; then
########################################################################
open -a Simulator
########################################################################
fi

########################################################################
if [ "${TYPE}" = "android" ]; then
########################################################################
~/Library/Android/sdk/emulator/emulator -avd Pixel_3a_Simulator &
########################################################################
fi
