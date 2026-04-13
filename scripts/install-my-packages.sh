#!/usr/bin/env bash

packages_file_path="$HOME/dotfiles/arch/my-packages.txt"

# Check if the file exists
if [[ ! -f "$packages_file_path" ]]; then
    echo "❌ Error: $PKG_FILE not found!"
    exit 1
fi

echo "Reading package list and syncing with paru..."

# 1. grep -v '^#'       -> Ignore lines that are JUST comments
# 2. sed 's/#.*//'      -> Remove everything after a # on any line
# 3. xargs              -> Pass the cleaned names to paru
grep -v '^#' "$packages_file_path" | sed 's/#.*//' | xargs -r paru -S --needed --noconfirm

echo "✅ System synchronization complete!"
