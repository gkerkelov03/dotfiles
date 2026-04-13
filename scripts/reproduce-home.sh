#!/usr/bin/env bash

# 1. Install core packages
echo "Installing essentials"
#These are suggested to install in hyperland config
paru -S --needed --noconfirm mesa-utils qt5-wayland hyprpolkitagent
#My stuff
paru -S --needed --noconfirm dos2unix noto-fonts-emoji noto-fonts-cjk projectdo neovim

# 2. Change shell to fish
if [ "$SHELL" != "/bin/fish" ]; then
    echo "Changing default shell to fish..."
    chsh -s /bin/fish
fi

# 3. Symlink dotfiles
echo "Running symlink-dotfiles script..."
bash $HOME/dotfiles/scripts/symlink-dotfiles.sh

# 4. Install Nix
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# 5. Source Nix
echo "Sourcing Nix profile..."
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# 6. Run Home-Manager
echo "Applying Home-Manager flake..."
nix run github:nix-community/home-manager -- switch --flake "$HOME/.config/home-manager#qwest"

# 7. Install dotnet and ef
paru -S --needed --noconfirm dotnet-sdk
dotnet tool install --global dotnet-ef

# 8. Install fisher and load fisher plugins
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | fish -c '
    source; 
    fisher update; 
    source ~/dotfiles/config/fish/conf.d/nvm.fish; 
    nvm install latest
'
echo "Done"
