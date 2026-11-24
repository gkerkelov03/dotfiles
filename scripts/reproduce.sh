#!/usr/bin/env bash
set -euo pipefail

#cleanup the .config folder because some random apps put some random stuff in there when installed
rm -rf ~/.config/*

# apply the dotfiles first so our caelestia cli and shell configs are in place otherwise caelestia is gonna put a bunch of bullshit in the .config folder
chezmoi --source ~/dotfiles init --apply

bash "./install-caelestia.sh"
bash "./setup-home-folders.sh"

#Install latest version of the fish plugins from and configure the prompt for the fish shell (tide)
fish -c 'fisher update && configure-tide'

#Install the exact version of the yazi plugins(commit hash) pinned in /yazi/package.toml
ya pkg install

#Install the latest Arch ISO straight into libvirt's folder (QEMU can read it there)
sudo wget -O /var/lib/libvirt/images/arch.iso https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso
bash "./create-arch-vm-in-virt-manager.sh"

#Make fish the default shell. It takes effect on your next login. The current shell session is unchanged
chsh -s /bin/fish

#Setup shell integration for worktrunk mainly for the sake of wt switch <branch> to
#be able to cd into the branche's directory and autocompletions
wt config shell install fish --yes

echo "Done"
