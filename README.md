1. **update apt:** sudo apt update && sudo apt full-upgrade
2. **install curl:** sudo apt install -y curl
3. **install nix:** curl -fsSL <https://install.determinate.systems/nix> | sh -s -- install
4. **restart the machine**
5. **clone the dotfiles repo:**
    1. git clone <https://gitlab.com/kerkelov/dotfiles> ~/dotfiles
    2. ln -s ~/dotfiles/dflinker ~/.local/bin/dflinker
    3. chmod +x ~/.local/bin/dflinker
6. **install home manager:** nix run home-manager/master -- switch --flake ~/.config/home-manager#qwest

