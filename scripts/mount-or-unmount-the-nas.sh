#!/usr/bin/env bash
set -euo pipefail

source "$HOME/dotfiles/scripts/read-keepassxc-entry.sh"

NAS_FOULDER_TO_MOUNT="//192.168.1.3/personal_folder"
MOUNT_POINT="$HOME/nas"
KEEPASSXC_ENTRY_NAME="nas-personal-account"

#the credentials file that we will fill in with credentials from read_keepassxc_entry
#it lives only in ram never touches the disk
CREDS="$XDG_RUNTIME_DIR/nas-creds"

#trap makes it so the code is ran when the script finishes. Its like the finally block of the script
#its mission is to cleanup the temporary file
trap 'rm -f "$CREDS"' EXIT

if mountpoint -q "$MOUNT_POINT"; then
  sudo umount "$MOUNT_POINT"
  echo "Unmounted $MOUNT_POINT"
  exit 0
fi

read_keepassxc_entry "$KEEPASSXC_ENTRY_NAME" NAS_USERNAME NAS_PASSWORD || {
  echo "Couldn't read entry '$KEEPASSXC_ENTRY_NAME'" >&2
  exit 1
}

#umask makes it so the credentials file is created with mode 600
#only you can read or write it. And those permissions are set before the file is
#created so no other user can ever touch it
umask 077

#write username=<username> \n password=<password>\n in the credentials file
printf 'username=%s\npassword=%s\n' "$NAS_USERNAME" "$NAS_PASSWORD" >"$CREDS"

sudo mount -t cifs "$NAS_FOULDER_TO_MOUNT" "$MOUNT_POINT" \
  -o "credentials=$CREDS,uid=$(id -u),gid=$(id -g),iocharset=utf8,vers=3.1.1"

echo "Successfully mounted $NAS_FOULDER_TO_MOUNT at $MOUNT_POINT"
