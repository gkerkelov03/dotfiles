#!/usr/bin/env bash

packages_file="$HOME/dotfiles/arch/packages.json"

paru -S --needed --noconfirm jq

jq -r '.[] | keys_unsorted[]' "$packages_file" | while read -r pkg; do
  paru -S --needed --noconfirm "$pkg"
done

echo "✅ Installation finished!"
