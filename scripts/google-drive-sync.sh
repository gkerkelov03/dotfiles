#!/usr/bin/env bash
set -euo pipefail
# Two-way sync of ~/sync with the "sync" folder on Google Drive.
#
# Usage:
#  ./google-drive-sync.sh      Run this when you are setting the google drive sync
#                              for the first time on a new machine
#                              or your sync folder stopped syncing for some reason
#                              or you changed filters.txt
#
#  ./google-drive-sync.sh run  used by the systemd service

# ---------------------------------------------------------------------------
# Settings
# ---------------------------------------------------------------------------
CLIENT_ID="your-id.apps.googleusercontent.com"

REMOTE="google-drive"
REMOTE_PATH="$REMOTE:sync"
LOCAL_PATH="$HOME/sync"
IGNORED_FILES="$HOME/.config/rclone/ignored-files.txt"
BACKUP_DIR="$HOME/.local/share/rclone-backups/sync"
SYSTEMD_SERVICE_NAME="google-drive-sync"

FLAGS=(
  --filters-file "$IGNORED_FILES"
  --drive-skip-gdocs
  --create-empty-src-dirs
  --conflict-resolve none
  --conflict-loser num
  --backup-dir2 "$BACKUP_DIR"
  --check-access
  --resilient --recover
  --max-lock 2m
)

bisync() { rclone bisync "$REMOTE_PATH" "$LOCAL_PATH" "${FLAGS[@]}" "$@"; }

# ---------------------------------------------------------------------------
# Timer mode: one normal sync, nothing else
# ---------------------------------------------------------------------------
case "${1:-setup}" in
run)
  bisync
  exit
  ;;
setup)
  ;;
*)
  echo "Usage: $(basename "$0") [run]" >&2
  exit 2
  ;;
esac

# ---------------------------------------------------------------------------
# Setup / repair mode
# ---------------------------------------------------------------------------
echo "==> Pausing the sync timer"
systemctl --user stop "$SYSTEMD_SERVICE_NAME.timer" 2>/dev/null || true
while systemctl --user is-active --quiet "$SYSTEMD_SERVICE_NAME.service"; do sleep 2; done

echo "==> Checking the rclone remote"
CURRENT_ID="$(rclone config show "$REMOTE" 2>/dev/null |
  awk -F' = ' '$1=="client_id"{print $2}' || true)"

if ! rclone listremotes | grep -qx "$REMOTE:"; then
  read -rsp "Google client secret: " CLIENT_SECRET
  echo
  rclone config create "$REMOTE" drive scope=drive \
    client_id="$CLIENT_ID" client_secret="$CLIENT_SECRET"
  unset CLIENT_SECRET
elif [[ "$CURRENT_ID" != "$CLIENT_ID" ]]; then
  echo "Client ID changed, updating the remote"
  read -rsp "Google client secret: " CLIENT_SECRET
  echo
  rclone config update "$REMOTE" \
    client_id="$CLIENT_ID" client_secret="$CLIENT_SECRET"
  unset CLIENT_SECRET
  rclone config reconnect "$REMOTE:"
fi

echo "==> Checking access to Google Drive"
if ! rclone lsf "$REMOTE:" --max-depth 1 >/dev/null 2>&1; then
  echo "Access failed, signing in to Google again"
  rclone config reconnect "$REMOTE:"
  rclone lsf "$REMOTE:" --max-depth 1 >/dev/null
fi

echo "==> Preparing folders and check-access markers"
mkdir -p "$LOCAL_PATH" "$BACKUP_DIR"
rclone mkdir "$REMOTE_PATH"
[[ -f "$LOCAL_PATH/RCLONE_TEST" ]] || touch "$LOCAL_PATH/RCLONE_TEST"
if [[ -z "$(rclone lsf "$REMOTE_PATH" --files-only --include /RCLONE_TEST)" ]]; then
  rclone copyto "$LOCAL_PATH/RCLONE_TEST" "$REMOTE_PATH/RCLONE_TEST"
fi

echo "==> Syncing"
if ! bisync; then
  echo "==> Normal sync failed (first run, changed filters or broken state)"
  echo "==> Rebuilding with --resync (the newer copy of each file wins)"
  bisync --resync --resync-mode newer
fi

echo "==> Enabling the sync timer"
systemctl --user daemon-reload
systemctl --user enable --now "$SYSTEMD_SERVICE_NAME.timer"

echo "Done. Sync runs on the timer from now on."
