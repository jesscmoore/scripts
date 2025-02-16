#!/bin/bash
#
# Time-stamp: <Sunday 2025-02-16 20:00:47 Jess Moore>
#
# Append to Ubuntu dock
#
# Usage: bash u_append_to_dock.sh google-chrome

application="'${1}.desktop'"
favourites="/org/gnome/shell/favorite-apps"
dconf write ${favourites} \
  "$(dconf read ${favourites} \
  | sed "s/, ${application}//g" \
  | sed "s/${application}//g" \
  | sed -e "s/]$/, ${application}]/")"
