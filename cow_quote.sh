#!/bin/bash
#
# Time-stamp: <Monday 2025-02-24 19:53:01 Jess Moore>
#
# Cowsay/cowthink sourcing fortune and user quotes.json
#
# Usage: cow_quote.sh

# TODO: quotes.json should be installed elsewhere, e.g. with Documents/scripts/home and softlink to Documents for ready editing
QUOTE_FILE=~/quotes.json

OS=`uname`
case "${OS}" in
'Linux')
    COWS_DIR="/opt/homebrew/share/cowsay/cows";
    COWS_BIN="/usr/games";;
'Darwin')
    COWS_DIR="$(brew --prefix)/share/cowsay/cows";
    COWS_BIN="$(brew --prefix)/bin";;
*)
    echo "Supported operating systems: Linux, Darwin. Not";;
esac

if [[ -e ${QUOTE_FILE} ]]; then

    # Random quote from fortune and my quotes.json
    # Get quote from fortune
    QUOTE_FORT="$(fortune)"
    # Get random quote concatenated with author from
    # user's quotes.json
    QUOTE_MY="$(cat $QUOTE_FILE  | jq -c '.[] | [.quote, .author]' | shuf -n 1 | sed 's/[][]//g')"

    echo "$QUOTE_FORT\n$QUOTE_MY" | shuf -n 1 | $(ls ${COWS_BIN}/cow* | shuf -n 1) -f $(ls ${COWS_DIR} | shuf -n 1)
    echo "(Source: fortune and my ~/quotes.json)."

else

    # Old method: Random quote from fortune sources only
    fortune | $(ls /usr/games/cow* | shuf -n 1) -f $(ls /usr/share/cowsay/cows/ | shuf -n 1)
    echo "(Source: fortune quotes)."

fi
