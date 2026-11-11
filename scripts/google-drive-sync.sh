#!/usr/bin/env bash
set -euo pipefail
# Two-way sync of ~/sync with the "sync" folder on Google Drive.
#
# Usage:
#  ./google-drive-sync.sh      Run this when you are setting the google drive sync
#                              for the first time on a new machine
#                              or your sync folder stopped syncing for some reason
#                              or you changed the ignored-files.txt
#
#  ./google-drive-sync.sh run  used by the systemd service

VAULT="$HOME/sync/credentials.kdbx"
VAULT_ENTRY="rclone"
YUBIKEY_SLOT=2

REMOTE="google-drive"
REMOTE_PATH="$REMOTE:sync"
LOCAL_PATH="$HOME/sync"
IGNORED_FILES="$HOME/.config/rclone/ignored-files.txt"
SYSTEMD_SERVICE_NAME="google-drive-sync"

FLAGS=(
  --filters-file "$IGNORED_FILES" # skip files matching these rules
  --drive-skip-gdocs              # skip Google Docs/Sheets/Slides
  --create-empty-src-dirs         # sync empty folders too
  --conflict-resolve none         # if both sides changed, don't pick a winner
  --conflict-loser num            # keep both, renamed .conflict1/.conflict2
  --check-access                  # refuse to sync without RCLONE_TEST on both sides
  --resilient                     # retry normally after minor errors
  --recover                       # recover automatically after an interrupted run
  --max-lock 2m                   # ignore lock files older than 2 minutes
)

bisync() { rclone bisync "$REMOTE_PATH" "$LOCAL_PATH" "${FLAGS[@]}" "$@"; }

#mode = the first argument passed to the script or <setup> if none were passed
MODE="${1:-setup}"

#this is basically the syntax in bash to make it run the bisync function and return
#if the argument was <run> otherwise run the <setup> function or show the usage.
if [[ "$MODE" == "run" ]]; then
  bisync
  exit
elif [[ "$MODE" != "setup" ]]; then
  echo "Usage: $(basename "$0") [run]" >&2
  exit 2
fi

#stop the timer so it doesn’t start a sync while the script is running
systemctl --user stop "$SYSTEMD_SERVICE_NAME.timer" 2>/dev/null || true
#if a timer-started sync is already running, wait until it finishes, checking every 2 seconds.
while systemctl --user is-active --quiet "$SYSTEMD_SERVICE_NAME.service"; do sleep 2; done

#start the timer again when the script exits, even if it failed
#because if some error happens like no internet or google sign in error
#the script will exit and the timer is going to stay stopped
trap 'systemctl --user start "$SYSTEMD_SERVICE_NAME.timer" 2>/dev/null || true' EXIT

setup() {
  echo "==> Reading CLIENT_ID and CLIENT_SECRET credentials from KeePassXC"
  load_credentials

  echo "==> Checking the rclone remote"
  if ! remote_exists; then
    # new machine: create the remote and sign in to your Google Account
    rclone config create "$REMOTE" drive scope=drive \
      client_id="$CLIENT_ID" client_secret="$CLIENT_SECRET" \
      --auto-confirm >/dev/null
  elif [[ "$(remote_setting client_id)" != "$CLIENT_ID" ||
  "$(remote_setting client_secret)" != "$CLIENT_SECRET" ]]; then
    # client ID or secret changed in KeePassXC: update the remote (signs in once)
    echo "Client ID or secret changed, updating the remote"
    rclone config update "$REMOTE" \
      client_id="$CLIENT_ID" client_secret="$CLIENT_SECRET" \
      --auto-confirm >/dev/null
  fi

  echo "==> Checking access to Google Drive"
  if ! drive_reachable; then
    # token expired or revoked: sign in again
    echo "Access failed, signing in to Google again"
    rclone config reconnect "$REMOTE:" --auto-confirm >/dev/null
    # still failing (e.g. no internet): stop here
    if ! drive_reachable; then
      echo "Still can't reach Google Drive. Check your connection." >&2
      exit 1
    fi
  fi

  echo "==> Preparing folders and check-access markers"
  # local marker
  if [[ ! -f "$LOCAL_PATH/RCLONE_TEST" ]]; then
    touch "$LOCAL_PATH/RCLONE_TEST"
  fi
  # remote marker
  if ! remote_marker_exists; then
    rclone copyto "$LOCAL_PATH/RCLONE_TEST" "$REMOTE_PATH/RCLONE_TEST"
  fi

  echo "==> Syncing"
  if ! bisync; then
    # first run, changed ignored files or broken state: rebuild from scratch
    echo "==> Normal sync failed, rebuilding with --resync (newer copy wins)"
    bisync --resync --resync-mode newer
  fi

  echo "==> Enabling the sync timer"
  systemctl --user daemon-reload                              # pick up unit file changes
  systemctl --user enable --now "$SYSTEMD_SERVICE_NAME.timer" # start now and at every login

  echo "Done. Sync runs on the timer from now on."
}

# read the client ID and secret from KeePassXC (asks for password + YubiKey touch)
load_credentials() {
  local out
  out="$(keepassxc-cli show --yubikey "$YUBIKEY_SLOT" \
    -a UserName -a Password "$VAULT" "$VAULT_ENTRY")"
  CLIENT_ID="$(sed -n 1p <<<"$out")"
  CLIENT_SECRET="$(sed -n 2p <<<"$out")"
}

# does the rclone remote exist?
remote_exists() {
  rclone listremotes | grep -qx "$REMOTE:"
}

# a setting the remote uses now, e.g. client_id (empty if none)
remote_setting() {
  rclone config show "$REMOTE" 2>/dev/null |
    awk -F' = ' -v key="$1" '$1==key{print $2}' || true
}

# can we reach Google Drive?
drive_reachable() {
  rclone lsf "$REMOTE:" --max-depth 1 >/dev/null 2>&1
}

# is the RCLONE_TEST marker on Google Drive?
remote_marker_exists() {
  [[ -n "$(rclone lsf "$REMOTE_PATH" --files-only --include /RCLONE_TEST)" ]]
}

# must stay the last line, after all functions are defined
setup
