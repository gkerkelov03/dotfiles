#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
  echo "Error: do not run this script with sudo or as root." >&2
  exit 1
fi

sudo pacman -Syu --noconfirm

bash "./install-paru.sh"
bash "./install-all-packages.sh"
bash "./install-caelestia.sh"
chezmoi --source ~/dotfiles init --apply
bash "./setup-home-folders.sh"
bash "./install-fisher-and-fish-plugins.sh"
bash "./install-yazi-plugins.sh"

#Install the dotnet ef tool
dotnet tool install --global dotnet-ef

#Install gh dash
gh extension install dlvhdr/gh-dash

#Install claude code
curl -fsSL https://claude.ai/install.sh | bash

#Install the latest arch linux iso so we have it available for virtual machines
wget -O ~/others/arch.iso https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso

#Make fish default shell
chsh -s /bin/fish

#Enable systemd services
systemctl enable plocate-updatedb.timer #the service that updates the db of the locate command (plocate package)
systemctl enable greetd                 #the login manager daemon
sudo systemctl enable libvirtd          #the libvirt daemon that receives requests from tools like virt-manager and carries them out

echo "Done"
