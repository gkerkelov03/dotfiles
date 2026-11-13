#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "Error: do not run this script with sudo or as root." >&2
  exit 1
fi

sudo pacman -Syu --noconfirm

bash "./install-paru.sh"
bash "./install-all-packages.sh"
bash "./install-fisher-and-fish-plugins.sh"
bash "./install-yazi-plugins.sh"
bash "./setup-home-folders.sh"

#cleanup the .config folder cuz some random apps put some random stuff in there when installed
rm -rf ~/.config/*

# first apply the dotfiles so our caelestia cli and shell configs are in place
# otherwise caelestia is gonna put a bunch of bullshit in the .config folder
chezmoi --source ~/dotfiles init --apply
bash "./install-caelestia.sh"

#Install the dotnet ef tool
dotnet tool install --global dotnet-ef

#Install gh dash
gh extension install dlvhdr/gh-dash

#Install claude code
curl -fsSL https://claude.ai/install.sh | bash

#Install the latest Arch ISO straight into libvirt's folder (QEMU can read it there)
sudo wget -O /var/lib/libvirt/images/arch.iso https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso

#Make fish default shell
chsh -s /bin/fish

#Setup shell integration for worktrunk mainly for the sake of wt switch <branch> to
#be able to cd into the branche's directory, also adds autocompletions
wt config shell install

#Enable systemd services
systemctl enable plocate-updatedb.timer #the service that updates the db of the locate command (plocate package)
sudo systemctl enable libvirtd          #the libvirt daemon that receives requests from tools like virt-manager and carries them out

echo "Done"
