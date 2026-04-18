#!/usr/bin/env bash

file=$1

# 1. Handle directories first
if [ -d "$file" ]; then
  # Use 'eza' or 'ls' to show folder contents instead of an error
  eza --tree --level=1 --icons --color=always "$file" 2>/dev/null || ls -F --color=always "$file"
  exit
fi

type=$(file --mime-type -b "$file")

# 2. Handle Images
if [[ $type == image/* ]]; then
  chafa --format=sixels --colors full --size="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" "$file"

# 3. Handle PDFs
elif [[ $type == application/pdf ]]; then
  echo "📄 PDF Document"
  # Pro tip: if you install 'exiftool', you can show metadata here:
  # exiftool "$file" | grep -E "Page Count|Title|Author"

# 4. Handle Text/Code
else
  # Added --theme and --terminal-width to ensure it looks good in the small fzf pane
  bat --color=always --style=numbers --line-range :500 "$file" 2>/dev/null
fi
