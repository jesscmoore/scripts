#!/bin/bash
#
# Time-stamp: <Friday 2025-03-12 20:29:02 Jess Moore>
#
# Create a gitignore file

function usage() {
    echo "Usage: $0 type"
    echo ""
    echo "Description: Creates a .gitignore file with standard"
    echo "ignore patterns for use in git repos."
    echo ""
    echo "Arguments:"
    echo "  type: One of 'generic', 'flutter', 'python'."
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

# Package type
TYPE=$1

case "${1}" in
    generic)

        echo "Creating .gitignore for: ${TYPE} project.";;

    flutter)

        echo "Creating .gitignore for: ${TYPE} project.";;

    python)

        echo "Creating .gitignore for: ${TYPE} project.";;

    *)
        echo "Supported options: generic, flutter, python.";
        exit;;
esac;


########################################################################
if [ "${TYPE}" = "generic" ]; then
########################################################################

cat > .gitignore << EOF
# Privacy & Security
*.env

# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.build/
.buildlog/
.history
.svn/
.swiftpm/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# The .vscode folder contains launch configuration and tasks you configure in
# VS Code which you may wish to be included in version control, so this line
# is commented out by default.
#.vscode/
EOF
########################################################################
fi

########################################################################
if [ "${TYPE}" = "flutter" ]; then
########################################################################

cat > .gitignore << EOF
# Privacy & Security
*.env

# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.build/
.buildlog/
.history
.svn/
.swiftpm/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# The .vscode folder contains launch configuration and tasks you configure in
# VS Code which you may wish to be included in version control, so this line
# is commented out by default.
#.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.pub-cache/
.pub/
/build/

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Androidss Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release
EOF
########################################################################
fi

########################################################################
if [ "${TYPE}" = "python" ]; then
########################################################################

cat > .gitignore << EOF
# Privacy & Security
*.env

# Data
data/

# Environment
.venv/

# Miscellaneous
*.log
*.pyc
*.swp
.DS_Store
.atom/
.build/
.buildlog/
.history
.svn/
.swiftpm/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# The .vscode folder contains launch configuration and tasks you configure in
# VS Code which you may wish to be included in version control, so this line
# is commented out by default.
#.vscode/

# API related
**/doc/api/

EOF
########################################################################
fi

echo "Successfully created .gitignore file for ${TYPE}."
