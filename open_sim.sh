#!/bin/bash
#
# Time-stamp: <Friday 2025-03-16 11:41:12 Jess Moore>
#
# Opening mobile development simulator.
#
# Usage: bash open_sim.sh

# Platform device type and name
IPAD_SIM=A9726D34-87EE-4371-88BE-1CE198E12C4C
PIX3A_SIM=Pixel_3a_Simulator

case "${1}" in
    ios)

        if [[ -z $2 ]]; then
            DEV_ID=${IPAD_SIM}
            echo "Opening ${1} ipad simulator.";
        else
            DEV_ID=$2
            echo "Opening ${1} ${2} simulator.";
        fi;;

    android)

        if [[ -z $2 ]]; then
            DEV_ID=${PIX3A_SIM}
            echo "Opening ${1} Pixel3A simulator.";
        else
            DEV_ID=$2
            echo "Opening ${1} ${2} simulator.";
        fi;;


    *)
        echo "Supported options";
        echo "\$1: ios, android.";
        echo "\$2: provide device id (Defaults ios: ipad id, android: pixel3a id).";
        exit;;
esac;

TYPE=$1


########################################################################
if [ "${TYPE}" = "ios" ]; then
########################################################################
open -a Simulator --args -CurrentDeviceUDID ${DEV_ID}
########################################################################
fi

########################################################################
if [ "${TYPE}" = "android" ]; then
########################################################################
~/Library/Android/sdk/emulator/emulator -avd Pixel_3a_Simulator &
########################################################################
fi
