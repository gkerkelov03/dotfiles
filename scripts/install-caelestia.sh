#!/usr/bin/env bash

#install caelestia but enable the installation for only the firefox and hypr components from its manifest file
#everything else we have already in our packages.json file
caelestia install --noconfirm \
  --disable-components fish,foot,fastfetch,btop,micro,thunar,starship,gtk,qt,auth,network,bluetooth,pipewire,clipboard,fonts,tools

# set default wallpaper and scheme
caelestia wallpaper -f ~/dotfiles/arch/hinata.jpg
caelestia scheme set -n onedark
