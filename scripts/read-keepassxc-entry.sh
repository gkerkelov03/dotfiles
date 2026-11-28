# Source this file in another script; never execute it by itself straight away.
VAULT_PATH="$HOME/sync/vault.kdbx"
YUBIKEY_SLOT=2

# read_keepassxc_entry ENTRY USER_VAR PASS_VAR
# Unlocks the vault (master password via fuzzel + YubiKey touch) and stores the
# entry's username/password in the variables named USER_VAR and PASS_VAR.
read_keepassxc_entry() {
    local entry_name=$1 # the first parameter passed to the script is the entry name

    #username and password are the variables from the outer script passed by reference
    #so when we change username and passowrd we change the variables in the outer script too
    local -n username=$2 password=$3

    #this declaration is on its own line on purpose cuz otherwise for some reason
    #we cannot detect if keepassxc-cli has failed or not
    local keepassxc_cli_output

    #the master password is always asked through a masked fuzzel prompt
    #declared on its own line for the same reason as above
    local master_password

    #if fuzzel is cancelled (Escape) it exits non-zero so we bail out here
    #instead of sending an empty master password to keepassxc-cli
    master_password=$(fuzzel --dmenu --password --prompt-only "Unlock vault: ")
    [[ -n $master_password ]] || return 1

    #keepassxc_cli_output will look like this so it needs to be splitted:
    #myuser\nmypassword\n
    #it is just a two line string with one word on each line
    #-q keeps keepassxc-cli quiet and the master password is piped in on stdin
    #since keepassxc-cli reads it from there when it is not run in a terminal
    keepassxc_cli_output=$(printf '%s\n' "$master_password" |
        keepassxc-cli show -q --yubikey "$YUBIKEY_SLOT" \
            -a UserName -a Password "$VAULT_PATH" "$entry_name") || return 1

    #we do not need the master password anymore so we do not keep it around
    unset master_password

    #assigns the contents of first line of keepassxc_cli_output to the variable username
    #and the contents of the second line to the variable password
    {
        read -r username
        read -r password
    } <<<"$keepassxc_cli_output"

    #This tests whether password is non-empty. It’s the function’s last command
    #so its result becomes the function’s exit code: 0 (success) if a password was found
    #1 (failure) if it’s empty. That’s what the caller’s || { echo ...; exit 1; } reacts to.
    [[ -n $password ]]
}
