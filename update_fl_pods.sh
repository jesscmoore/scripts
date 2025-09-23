#!/bin/bash
#
# Time-stamp: <Tuesday 2025-09-23 09:07:16 Jess Moore>
#
# Update cocoa pods after a new macos and/or xcode update
#
# Usage: update_fl_pods.sh [args...]

function usage() {
    echo "Usage: update_fl_pods.sh [ios_target]"
    echo ""
    echo "Description: Update cocoa pods after a new macos and/or xcode update. Run script from flutter project top level folder."
    echo ""
    echo "Arguments:"
    echo "  ios_target:  Target iOS operating system version, eg. 17.0 (No default.)"
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

if [[ $# -eq 1 ]]; then
        NEW_TARGET=$1
fi

FIND_LIB=$(find . -type d -iname "lib")

if [[ $FIND_LIB == "./lib" ]]; then
    echo "Confirmed running in flutter folder (found: ${FIND_LIB})."
else
    echo "lib folder not found."
    usage
fi

echo "======================================="
echo "cocoapods:"

echo "First run: "
echo "sudo gem update xcodeproj"
echo "sudo gem install cocoapods"

echo "======================================="
echo "flutter clean & flutter pub get:"

flutter clean
flutter pub get

echo "======================================="
echo "macos:"

cd macos || return

MACOS_EXPECTED="Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"
APP_MACOS_CONFIG=Runner/Configs/AppInfo.xcconfig


# Removing old Pods dir and Podfile.lock file
rm -rf Pods
rm -rf Podfile.lock

if cat ${APP_MACOS_CONFIG} | grep "${MACOS_EXPECTED}" >/dev/null; then
    echo "Base configuration for debug, release and profile already set in ${APP_MACOS_CONFIG}.";
else
cat >> "${APP_MACOS_CONFIG}" << EOF
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig"
EOF
    echo "Base configuration for debug, release and profile added to ${APP_MACOS_CONFIG}"
fi

# Update pods
pod repo update
pod update

cd ../.

echo "======================================="
echo "ios:"

cd ios || return

IOS_EXPECTED="Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig"
APP_IOS_CONFIG=Flutter/Release.xcconfig

# Removing old Pods dir and Podfile.lock file
rm -rf Pods
rm -rf Podfile.lock

if cat ${APP_IOS_CONFIG} | grep "${IOS_EXPECTED}" >/dev/null; then
    echo "Base configuration for debug, release and profile already set in ${APP_IOS_CONFIG}.";
else
cat >> "${APP_IOS_CONFIG}" << EOF
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig"
EOF
    echo "Base configuration for release added to ${APP_IOS_CONFIG}"
fi


# Update target OS in Podfile if updated target provided
if [[ $# -eq 1 ]]; then

    IOS_PODFILE=Podfile
    CURR_TARGET_LINE=$(cat Podfile | grep "platform :ios")
    # CURR_TARGET=$(${CURR_TARGET_LINE} | awk '{print $NF}')
    ORIG_TARGET_LINE_START="# platform :ios"
    UPDATED_TARGET_LINE_START="platform :ios"

    if cat ${IOS_PODFILE} | grep "${ORIG_TARGET_LINE_START}" >/dev/null; then

        echo "Podfile lacks a iOS deployment target."
        perl -pi -e "s|${CURR_TARGET_LINE}|platform :ios, '${NEW_TARGET}'|" ${IOS_PODFILE}
        echo "Podfile iOS deployment target updated to:"
        cat ${IOS_PODFILE} | grep "${UPDATED_TARGET_LINE_START}"

    else
        echo "Podfile already has a iOS deployment target specified."
    fi

fi

# Update pods
pod repo update
pod update

cd ../.

echo "======================================="
echo "pod --version"
pod --version
echo "Done."
echo "Now restart VSCode."

# macos output:
#
# Generating Pods project
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Invalid key/value pair: DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzUuNA==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049ZDY5M2I0YjlkYg==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049YzI5ODA5MTM1MQ==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My45LjI=
# Integrating client project


# ios output:
#
# Pod installation complete! There are 6 dependencies from the Podfile and 6 total pods installed.
