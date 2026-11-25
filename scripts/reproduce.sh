#!/usr/bin/env bash
set -euo pipefail

#cleanup the .config folder because some random apps put some random stuff in there when installed
rm -rf ~/.config/*

# apply the dotfiles first so our caelestia cli and shell configs are in place otherwise caelestia is gonna put a bunch of bullshit in the .config folder
chezmoi --source ~/dotfiles init --apply

bash "./install-caelestia.sh"
bash "./setup-home-folders.sh"
bash "./setup-greetd-and-airlock.sh"

#Install latest version of the fish plugins from and configure the prompt for the fish shell (tide)
fish -c 'fisher update && configure-tide'

#Install the exact version of the yazi plugins(commit hash) pinned in /yazi/package.toml
ya pkg install

#Install the latest Arch ISO straight into libvirt's folder (QEMU can read it there)
sudo wget -O /var/lib/libvirt/images/arch.iso https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso
bash "./create-arch-vm-in-virt-manager.sh"

#Make fish the default shell. It takes effect on your next login. The current shell session is unchanged
chsh -s /bin/fish

#Setup shell integration for worktrunk mainly for autocompletions and for wt switch <branch> to be able to cd into the branche's directory, which is done by just putting a wrapper function wt.fish into fish/functions
wt config shell install fish --yes

#the service that updates the db of the locate command (plocate package)
sudo systemctl enable --now plocate-updatedb.timer

#the service that needs to be running so tools that expect docker can work with podman seamlessly
systemctl --user enable --now podman.socket

#the libvirt daemon that receives requests from tools like virt-manager and carries them out
sudo systemctl enable --now libvirtd

#autostart libvirt's default network so that the VMs can get an IP address from the DHCP server that libvirt runs
sudo virsh net-autostart default

echo "Done"
