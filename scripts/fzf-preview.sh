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
elif [[ $type == video/* || $type == image/gif ]]; then
  # -ss 00:00:05  -> Seek to 5 seconds (to avoid black intros)
  # -i "$file"    -> Input file
  # -vf "scale=640:-1" -> Resize to 640px wide (maintains aspect ratio)
  # -frames:v 1   -> Grab exactly one frame
  # -f image2     -> Output as an image format
  # -pipe:v 1     -> Send it to stdout
  ffmpeg -hide_banner -loglevel error -ss 00:00:02 -i "$file" \
    -vf "scale=640:-1" -frames:v 1 -f image2 - |
    chafa --format=sixels --size="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" -
elif [[ $type == application/pdf ]]; then
  if [ ! -f "$CACHE" ]; then
    mutool draw -o "$CACHE" "$file" 1 2>/dev/null
  fi
  chafa --format=sixels --size="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" "$CACHE"
elif [[ $type == application/vnd.openxmlformats-officedocument.* || $type == application/msword || $type == application/vnd.ms-* ]]; then
  if [ ! -f "$CACHE" ]; then
    # Use LibreOffice to export page 1 as a PDF to /tmp
    libreoffice --headless --convert-to pdf --outdir /tmp "$file" >/dev/null 2>&1

    # Identify the temp PDF name (LibreOffice names it based on the file)
    TEMP_PDF="/tmp/$(basename "${file%.*}").pdf"

    # Convert that PDF page to our final PNG cache using mutool
    if [ -f "$TEMP_PDF" ]; then
      mutool draw -o "$CACHE" "$TEMP_PDF" 1 2>/dev/null
      rm "$TEMP_PDF"
    fi
  fi

  # If we successfully created a cache, show it; otherwise, show info
  if [ -f "$CACHE" ]; then
    chafa --format=sixels --size="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" "$CACHE"
  else
    echo "Visual preview failed. Showing metadata:"
    file "$file"
  fi
else
  bat --color=always --style=numbers --line-range :500 "$file" 2>/dev/null
fi
