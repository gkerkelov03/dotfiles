#!/usr/bin/env bash
set -euo pipefail

sudo pacman -S --needed --noconfirm base-devel git

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git clone --depth=1 https://aur.archlinux.org/paru.git "$tmp/paru"
(cd "$tmp/paru" && makepkg -si --noconfirm)

echo "✅ paru installed successfully!"
