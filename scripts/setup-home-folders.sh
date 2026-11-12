#!/usr/bin/env bash
set -euo pipefail

cd "$HOME"

rmdir Desktop Documents Downloads Music Pictures Public Templates Videos Projects 2>/dev/null || true

mkdir -p \
  backup \
  nas \
  sync \
  other \
  repos \
  downloads \
  junk \
  media/gifs \
  media/pictures \
  media/recordings \
  media/videos \
  media/wallpapers/live-wallpapers

xdg-user-dirs-update

echo "Done!"
