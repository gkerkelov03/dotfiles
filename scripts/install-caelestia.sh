#!/usr/bin/env bash

# Packages to skip
exclude=(
  "starship"
)

# Fetch and parse depends from PKGBUILD
raw=$(curl -s "https://raw.githubusercontent.com/caelestia-dots/caelestia/main/PKGBUILD")

deps=($(echo "$raw" |
  grep -A 999 "^depends=(" |
  grep -m1 -oP "(?<=depends=\().*?(?=\))" |
  tr -d "'" |
  tr -s " \n" "\n"))

if [[ ${#deps[@]} -eq 0 ]]; then
  echo "Failed to fetch dependencies. Check your internet connection."
  exit 1
fi

# Filter out excluded packages
to_install=()
for pkg in "${deps[@]}"; do
  skip=false
  for ex in "${exclude[@]}"; do
    [[ "$pkg" == "$ex" ]] && skip=true && break
  done
  $skip || to_install+=("$pkg")
done

echo "Installing: ${to_install[*]}"
paru -S --needed "${to_install[@]}"
