#!/usr/bin/env bash

# Preview any file or folder in fzf:
#   fzf --preview '~/dotfiles/scripts/fzf-preview.sh {}'
#
# Also accepts ripgrep-style "path:line:..." input and highlights that line.
#
# Only bash and file are required. If a tool is missing or fails, the preview
# falls back to something simpler, ending with the file's basic details.
#
# Optional tools:
#   text       bat
#   folders    eza
#   images     chafa, plus rsvg-convert or magick for SVG
#   video      ffmpeg
#   audio      ffprobe
#   PDF/EPUB   mutool or pdftoppm (PDF only)
#   Office     libreoffice
#   archives   bsdtar, or tar/unzip/7z
#   databases  sqlite3
#   binaries   xxd
#
# Set FZF_PREVIEW_IMAGE_FORMAT to change the image format (default: sixels).

set -u

max_lines=500
image_format=${FZF_PREVIEW_IMAGE_FORMAT:-sixels}
columns=${FZF_PREVIEW_COLUMNS:-80}
lines=${FZF_PREVIEW_LINES:-24}
# One line shorter, so an image can't scroll the preview window.
image_size="${columns}x$((lines > 1 ? lines - 1 : 1))"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/fzf-preview"
work_dir=""

has() { command -v "$1" >/dev/null 2>&1; }

cleanup() { [[ -n $work_dir ]] && rm -rf "$work_dir"; }
trap cleanup EXIT
# fzf kills the preview when you move to another item.
trap 'exit 143' INT TERM

show_info() {
  file -Lb -- "$file"
  stat -L --printf='Size: %s bytes\nModified: %y\nPermissions: %A\n' -- "$file" 2>/dev/null
}

show_image() {
  has chafa && chafa --format="$image_format" --colors=full --animate=off \
    --size="$image_size" "$1" 2>/dev/null
}

show_text() {
  if has bat; then
    local range=":$max_lines" highlight=()
    if [[ -n $line ]]; then
      # Keep the matching line near the top of the preview.
      range="$((line > 10 ? line - 10 : 1)):$((line + max_lines))"
      highlight=(--highlight-line "$line")
    fi
    bat --color=always --style=numbers --line-range="$range" "${highlight[@]}" "$file"
  else
    head -n "$max_lines" -- "$file"
  fi
}

show_directory() {
  if has eza; then
    eza --tree --level=2 --icons --color=always --group-directories-first "$file"
  else
    ls -la --color=always -- "$file"
  fi
}

show_archive() {
  if has bsdtar; then
    bsdtar -tf "$file"
  elif has 7z; then
    7z l "$file"
  elif has unzip && [[ $mime == application/zip ]]; then
    unzip -l "$file"
  elif has tar; then
    tar -tf "$file"
  else
    return 1
  fi 2>/dev/null | head -n "$max_lines"
  ((PIPESTATUS[0] == 0))
}

show_audio() {
  has ffprobe || return 1
  ffprobe -v error -show_entries \
    format=duration,bit_rate:format_tags=title,artist,album,date,genre,track \
    -of default=noprint_wrappers=1 "$file"
}

show_database() {
  has sqlite3 || return 1
  sqlite3 -readonly "$file" .schema 2>/dev/null | head -n "$max_lines"
  ((PIPESTATUS[0] == 0))
}

show_binary() {
  show_info
  if has xxd; then
    echo
    xxd -l 512 "$file"
  fi
}

thumb_video() {
  has ffmpeg || return 1
  local args=(-nostdin -v error -y -i "$file" -frames:v 1 -vf 'scale=800:-2' -update 1 "$1")
  # Skip the first seconds to avoid a black intro. Short videos need a retry.
  ffmpeg -ss 2 "${args[@]}" 2>/dev/null
  [[ -s $1 ]] || ffmpeg "${args[@]}" 2>/dev/null
}

render_pdf() {
  if has mutool; then
    mutool draw -q -r 100 -o "$2" "$1" 1 2>/dev/null
  elif has pdftoppm && [[ $1 == *.pdf || $mime == application/pdf ]]; then
    pdftoppm -f 1 -l 1 -singlefile -png -scale-to 1000 "$1" "${2%.png}" 2>/dev/null
  else
    return 1
  fi
}

thumb_document() { render_pdf "$file" "$1"; }

thumb_office() {
  has libreoffice || return 1
  # A separate profile lets this run even while LibreOffice is open.
  timeout 60 libreoffice --headless \
    "-env:UserInstallation=file://$cache_dir/libreoffice-profile" \
    --convert-to pdf --outdir "$work_dir" "$file" >/dev/null 2>&1 || return 1
  local pdf name=${file##*/}
  pdf="$work_dir/${name%.*}.pdf"
  [[ -s $pdf ]] && render_pdf "$pdf" "$1"
}

thumb_svg() {
  if has rsvg-convert; then
    rsvg-convert -w 1000 -o "$1" "$file" 2>/dev/null
  elif has magick; then
    magick -density 150 "$file" "$1" 2>/dev/null
  else
    return 1
  fi
}

# Show a slow-to-make thumbnail, creating it only once per version of the file.
show_cached() {
  has chafa || return 1
  local key cache
  key=$(stat -Lc '%n %Y %s' -- "$file" | sha1sum)
  cache="$cache_dir/${key%% *}.png"

  if [[ ! -s $cache ]]; then
    mkdir -p "$cache_dir" || return 1
    work_dir=$(mktemp -d) || return 1
    # Moved into place only once complete, in case fzf kills the preview.
    "$1" "$work_dir/out.png" && [[ -s $work_dir/out.png ]] || return 1
    mv -f "$work_dir/out.png" "$cache"
    find "$cache_dir" -maxdepth 1 -name '*.png' -mtime +30 -delete 2>/dev/null
  fi
  show_image "$cache"
}

target=${1:-}
file=$target
line=""

# Treat "path:line:..." as a location, unless that's the file's real name.
if [[ ! -e $file && $file == *:* ]]; then
  file=${target%%:*}
  line=${target#*:}
  line=${line%%:*}
  [[ $line =~ ^[0-9]+$ ]] || line=""
fi

if [[ -z $file ]]; then
  exit 0
elif [[ ! -e $file ]]; then
  echo "Not found: $file"
  exit 0
fi

# An absolute path means names starting with "-" can't be read as options.
file=$(realpath -- "$file")

if [[ -d $file ]]; then
  show_directory
  exit 0
fi

if [[ ! -r $file ]]; then
  echo "Permission denied"
  show_info
  exit 0
fi

if [[ ! -s $file ]]; then
  echo "Empty file"
  exit 0
fi

mime=$(file -Lb --mime-type -- "$file")
encoding=$(file -Lb --mime-encoding -- "$file")

case $mime in
image/svg*) show_cached thumb_svg || show_text ;;
image/*) show_image "$file" || show_info ;;
video/*) show_cached thumb_video || show_info ;;
audio/*) show_audio || show_info ;;
application/pdf | application/epub+zip) show_cached thumb_document || show_info ;;
application/vnd.openxmlformats-officedocument.* | \
  application/vnd.oasis.opendocument.* | \
  application/vnd.ms-* | application/msword | \
  text/rtf | application/rtf)
  show_cached thumb_office || show_info
  ;;
application/zip | application/x-tar | application/gzip | application/x-gzip | \
  application/x-bzip2 | application/x-xz | application/zstd | \
  application/x-7z-compressed | application/vnd.rar | application/x-rar | \
  application/java-archive | application/vnd.debian.binary-package | \
  application/x-rpm | application/x-iso9660-image)
  show_archive || show_info
  ;;
application/vnd.sqlite3 | application/x-sqlite3) show_database || show_info ;;
*)
  if [[ $encoding == binary ]]; then
    show_binary
  else
    show_text
  fi
  ;;
esac

exit 0
