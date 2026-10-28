#!/usr/bin/env bash
# No `set -e`: we handle errors per-link instead of aborting
set -uo pipefail
shopt -s dotglob nullglob

REPO="$HOME/dotfiles"

ok=()
failed=()

link() {
  local src="$1" dest="$2" err
  # Already in place: dest resolves to the same thing as src
  if [ -e "$dest" ] && [ "$(realpath "$dest")" = "$(realpath "$src")" ]; then
    ok+=("$dest -> $src (already linked)")
    return
  fi
  if err=$(ln -snfT "$src" "$dest" 2>&1); then
    ok+=("$dest -> $src")
  else
    failed+=("$dest -> $src"$'\n'"      ${err}")
  fi
}

ensure_dir() {
  local err
  if ! err=$(mkdir -p "$1" 2>&1); then
    failed+=("mkdir $1"$'\n'"      ${err}")
  fi
}

ensure_dir "$HOME/.config"

for f in "$REPO/config/"*; do
  if [ -d "$f" ] && [ "$(basename "$f")" = "home-dir" ]; then
    for home_file in "$f/"*; do
      link "$home_file" "$HOME/$(basename "$home_file")"
    done
  else
    link "$f" "$HOME/.config/$(basename "$f")"
  fi
done

ensure_dir "$HOME/.config/fish/functions"
for f in "$REPO/scripts/fish-functions/"*; do
  link "$f" "$HOME/.config/fish/functions/$(basename "$f")"
done

# ---- report ----
echo
echo "Linked (${#ok[@]}):"
for line in "${ok[@]}"; do echo "  ✓ $line"; done

if [ ${#failed[@]} -gt 0 ]; then
  echo
  echo "Failed (${#failed[@]}):"
  for line in "${failed[@]}"; do echo "  ✗ $line"; done
  exit 1
fi

echo
echo "All done, no failures."
