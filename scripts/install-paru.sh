#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "Run this as a normal user, not root." >&2
  exit 1
fi

sudo pacman -Syu --noconfirm

if ! paru --version &>/dev/null; then
  # Remove broken prebuilt paru, only the parts that are installed
  pacman -Qq paru-bin paru-bin-debug 2>/dev/null \
    | sudo pacman -Rns --noconfirm - || true

  sudo pacman -S --needed --noconfirm base-devel git

  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  git clone https://aur.archlinux.org/paru.git "$tmp/paru"
  (cd "$tmp/paru" && makepkg -si --noconfirm)
fi

paru --version