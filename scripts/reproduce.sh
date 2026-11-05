#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
  echo "Error: do not run this script with sudo or as root." >&2
  exit 1
fi

sudo pacman -Syu --noconfirm

bash "./install-paru.sh"
bash "./install-all-packages-from-the-packages-file.sh"
bash "./install-caelestia.sh"
chezmoi --source ~/dotfiles init

bash "./setup-home-folders.sh"
bash "./install-fisher-and-fish-plugins.sh"
bash "./install-yazi-plugins.sh"

#Install the dotnet ef tool
dotnet tool install --global dotnet-ef

#Install gh dash
gh extension install dlvhdr/gh-dash

#Install claude code
curl -fsSL https://claude.ai/install.sh | bash

#Make fish default shell
chsh -s /bin/fish

#Enable systemd services
systemctl enable --now plocate-updatedb.timer # The service that updates the db of the locate command (plocate package)
systemctl --user enable --now hyprpolkitagent wireplumber
systemctl enable greetd

echo "Done"
