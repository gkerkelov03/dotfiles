#!/usr/bin/env bash

echo 'Installing hypr config from caelestia dots...'
git clone --depth 1 --no-checkout https://github.com/caelestia-dots/caelestia.git tmp
cd tmp || exit
git checkout HEAD hypr

cd ..
rm -rf "$HOME/dotfiles/config/hypr"
mv tmp/hypr "$HOME/dotfiles/config/"
rm -rf tmp

chmod u+x "$HOME/dotfiles/config/hypr/scripts/wsaction.fish"
caelestia scheme set -n onedark
