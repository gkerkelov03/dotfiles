#!/usr/bin/env bash

paru -S caelestia-cli
caelestia install

# delete some caelestia defaults that we don't need
paru -Rs starship thunar micro
paru -c

# delete config folders for apps/tools cuz caelestia copy pastes all dotfiles.
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
  foot
