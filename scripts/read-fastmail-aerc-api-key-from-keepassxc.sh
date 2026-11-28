#!/usr/bin/env bash

source "./read-keepassxc-entry.sh"

read_keepassxc_entry "accessed-in-scripts/fastmail-aerc-api-key" fm_user fm_token < <(printf '%s\n' "$pw") || exit 1

printf '%s\n' "$fm_token"
