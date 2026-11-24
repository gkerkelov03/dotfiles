scrape="ytdlp"
show_thumbnails=1
thumbnail_viewer="kitty"

downloader() {
    for url in "$@"; do
        "$ytdl_path" -P "$HOME/downloads" "$url"
    done
}
