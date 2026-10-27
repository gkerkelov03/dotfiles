#!/usr/bin/env bash

#Install paru if not already installed
command -v paru &>/dev/null || {
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
  (cd /tmp/paru && makepkg -si --noconfirm)
  rm -rf /tmp/paru
}