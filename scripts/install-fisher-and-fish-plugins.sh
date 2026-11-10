#!/usr/bin/env bash
set -euo pipefail

curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | fish -c '
    source
    and fisher update
    and source ~/.config/fish/conf.d/nvm.fish
    and nvm install latest
    and nvm install lts
    and configure-tide
'
