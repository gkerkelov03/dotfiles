#!/usr/bin/env bash
set -euo pipefail

disabled_components=(
  fish
  foot
  fastfetch
  btop
  micro
  thunar
  starship
  gtk
  qt
  auth
  network
  bluetooth
  pipewire
  clipboard
  fonts
  tools
)

#install caelestia but enable only the firefox and hypr components
caelestia install --noconfirm --aur-helper paru \
  --disable-components "$(
    IFS=,
    echo "${disabled_components[*]}"
  )"

# set default wallpaper and scheme
caelestia wallpaper -f ~/dotfiles/arch/hinata.jpg
caelestia scheme set -n onedark
