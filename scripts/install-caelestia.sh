#!/usr/bin/env bash

#install caelestia but enable the installation for only the firefox component from its manifest file
#everything else we have already in our packages.json file
caelestia install --noconfirm \
  --disable-components hypr,fish,foot,fastfetch,btop,micro,thunar,starship,gtk,qt,auth,network,bluetooth,pipewire,clipboard,fonts,tools

# set default wallpaper and scheme
caelestia wallpaper -f ~/dotfiles/arch/hinata.jpg
caelestia scheme set -n onedark

pkg r thunar micro

# delete config folders for apps/tools we don't have cuz caelestia copy pastes all dotfiles.
cd ~/.config
rm -rf cava go htop nvtop
