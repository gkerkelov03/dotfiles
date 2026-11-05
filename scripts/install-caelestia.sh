#!/usr/bin/env bash

paru -S caelestia-cli --noconfirm
caelestia install --noconfirm

# set default wallpaper and scheme
caelestia wallpaper -f ~/dotfiles/arch/hinata.jpg
caelestia scheme set -n onedark

# delete some caelestia defaults that we don't need
paru -Rs starship thunar micro
paru -c

# delete config folders for apps/tools we don't have cuz caelestia copy pastes all dotfiles.
cd ~/.config

rm -rf \
  cava \
  go \
  htop \
  micro \
  nvtop \
  Thunar \
  Vencord \
  starship.toml \
  fastfetch \
  foot \
  fish
