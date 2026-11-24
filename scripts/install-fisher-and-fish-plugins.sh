#!/usr/bin/env bash
set -euo pipefail

curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | fish -c '
    source
    and fisher update
    and configure-tide
'
