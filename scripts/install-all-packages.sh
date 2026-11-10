#!/usr/bin/env bash

file="$HOME/dotfiles/arch/packages.json"

pkg add --silent jq

jq -r '.[] | keys_unsorted[]' "$file" | while read -r pkg; do
  pkg add --silent "$pkg"
done

echo "✅ Installation finished!"
