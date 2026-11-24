#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "Error: do not run this script as root." >&2
    exit 1
fi

sudo pacman -Syu --needed --noconfirm base-devel git jq

packages_file="$HOME/dotfiles/arch/packages.json"
failed_pkgs=()

# Install paru if not already installed
if ! command -v paru >/dev/null 2>&1; then
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    git clone --depth=1 https://aur.archlinux.org/paru.git "$tmp/paru"
    (cd "$tmp/paru" && makepkg -si --noconfirm)
fi

# Install all packages from the packages.json file
while IFS= read -r pkg; do
    [[ -z "$pkg" ]] && continue
    if ! paru -S --needed --noconfirm "$pkg"; then
        echo "Warning: failed to install '$pkg', skipping." >&2
        failed_pkgs+=("$pkg")
    fi
done < <(jq -r '.[] | keys_unsorted[]' "$packages_file")

# Report the results
echo "Installation finished!"
if ((${#failed_pkgs[@]} > 0)); then
    echo "Failed packages (${#failed_pkgs[@]}): ${failed_pkgs[*]}" >&2
fi
