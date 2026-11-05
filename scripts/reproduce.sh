#!/usr/bin/env bash

bash "./install-paru.sh"
bash "./install-all-packages-from-the-packages-file.sh"
chezmoi --source ~/dotfiles init
bash "./install-caelestia.sh"
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
