#!/usr/bin/env bash
set -euo pipefail

source "$HOME/dotfiles/scripts/read-keepassxc-entry.sh"

SHARE="//nas/personal_folder" # MagicDNS name or IP
MNT="$HOME/nas"
ENTRY="NAS" # keepassxc entry title/path in the database
CREDS="$XDG_RUNTIME_DIR/nas-creds"

if mountpoint -q "$MNT"; then
  sudo umount "$MNT"
  echo "Unmounted $MNT"
  exit 0
fi

mkdir -p "$MNT"

# Prompts for master password + YubiKey touch in this terminal
read_keepassxc_entry "$ENTRY" NAS_USER PASS || {
  echo "Couldn't read entry '$ENTRY'" >&2
  exit 1
}

umask 077
trap 'rm -f "$CREDS"' EXIT
printf 'username=%s\npassword=%s\n' "$NAS_USER" "$PASS" >"$CREDS"
unset PASS

sudo mount -t cifs "$SHARE" "$MNT" \
  -o "credentials=$CREDS,uid=$(id -u),gid=$(id -g),iocharset=utf8,vers=3.1.1"
echo "Mounted $SHARE at $MNT"
