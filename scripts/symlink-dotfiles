#!/usr/bin/env bash

#exit if any command fails
set -e
#ensure * includes hidden files
shopt -s dotglob

REPO="$HOME/dotfiles"
mkdir -p "$HOME/.config"

for f in "$REPO/config/"*; do
    #if f doesn't exist continue. Needed because bash treats empty directories wierd
    [ -e "$f" ] || continue

    FILENAME=$(basename "$f")

    # Check if the current item is a directory named 'home-dir'
    if [ -d "$f" ] && [ "$FILENAME" == "home-dir" ]; then
        for home_file in "$f/"*; do
            #if $home_file doesn't exist continue. Needed because bash treats empty directories wierd
            [ -e "$home_file" ] || continue
            ln -snfT "$home_file" "$HOME/$(basename "$home_file")"
        done
    else
        ln -snfT "$f" "$HOME/.config/$FILENAME"
    fi
done

echo "done"
