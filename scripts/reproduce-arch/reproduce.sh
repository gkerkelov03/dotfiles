#!/usr/bin/env bash

bash "./install-all-packages-from-the-packages-file.sh"
bash "./update-hyprland-config.sh"
bash "./symlink-dotfiles.sh"

#Install dotnet ef tool
dotnet tool install --global dotnet-ef

#Install gh dash
gh extension install dlvhdr/gh-dash

#Install fisher and load fisher plugins
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | fish -c '
    source; 
    fisher update; 
    source ~/dotfiles/config/fish/conf.d/nvm.fish; 
    nvm install latest
    nvm install lts
'

#Install claude code
curl -fsSL https://claude.ai/install.sh | bash

#Install yazi plugins
ya pkg install
ya pkg upgrade

#Make fish default shell
chsh -s /bin/fish

#Enable and disable systemd services
sudo systemctl enable --now plocate-updatedb.timer # The service that updates the db of the locate command (plocate package)
sudo systemctl --user enable --now hyprpolkitagent wireplumber
sudo systemctl enable greetd

echo "Done"
