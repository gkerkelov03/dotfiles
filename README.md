1. update apt - sudo apt update && sudo apt full-upgrade
2. install curl - sudo apt install -y curl
3. install nix curl -fsSL <https://install.determinate.systems/nix> | sh -s -- install
4. restart the machine
5. clone the dotfiles repo
    git clone <https://gitlab.com/kerkelov/dotfiles> ~/dotfiles
    ln -s ~/dotfiles/dflinker ~/.local/bin/dflinker
    chmod +x ~/.local/bin/dflinker
6. install home manager
7. nix run home-manager/master -- switch --flake ~/.config/home-manager#qwest

