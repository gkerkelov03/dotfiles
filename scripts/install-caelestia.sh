#!/usr/bin/env bash

caelestia install --noconfirm

# set default wallpaper and scheme
caelestia wallpaper -f ~/dotfiles/arch/hinata.jpg
caelestia scheme set -n onedark

# delete config folders for apps/tools we don't have cuz caelestia copy pastes all dotfiles.
cd ~/.config
rm -rf cava go htop nvtop
