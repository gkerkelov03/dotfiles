1. **Update the system**
    * **Debian:** sudo apt update && sudo apt full-upgrade -y
    * **Arch:** sudo pacman -Syu --noconfirm
    * **Red Hat**: sudo dnf upgrade --refresh -y
2. **Setup the dotfiles:**
    * git clone <https://gitlab.com/kerkelov/dotfiles> ~/dotfiles
    * ln -s ~/dotfiles/scripts/symlink-dotfiles ~/.local/bin/symlink-dotfiles
    * chmod +x ~/dotfiles/scripts/symlink-dotfiles && symlink-dotfiles
3. **Install nix:** ~/dotfiles/scripts/install-nix
4. **Reboot the system**
5. **Install home manager:** nix run home-manager/master -- switch --flake ~/.config/home-manager#qwest

