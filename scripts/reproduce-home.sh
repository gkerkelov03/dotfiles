#!/usr/bin/env bash

#Install paru if not already installed
command -v paru &>/dev/null || {
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
  (cd /tmp/paru && makepkg -si --noconfirm)
  rm -rf /tmp/paru
}

bash "./install-all-packages.sh"
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

#Make fish default shell
chsh -s /bin/fish

echo "Done"
