#!/bin/bash

# Create the greeter user only if your greetd package did not provide one
getent passwd greeter >/dev/null ||
  sudo useradd -r -M -s /usr/bin/nologin -d /var/cache/astra-airlock greeter

# Add the user to groups required by the greeter
sudo usermod -aG video,input greeter

# Create the state/cache directory for persistent settings & session memory
sudo install -d -m 0755 -o greeter -g greeter /var/cache/astra-airlock

# Sets up profile picture in astra lock
# Automatically identifies your user from SUDO_USER
sudo astra-airlock --set-pfp /home/gkerkelov03/dotfiles/home-configs/dot_face

#It makes this file so only root has write permissions cuz it is needed becaue this file
#Lets a command to be run by sudo without a password and for this to work the file has
#to be trustworthy and not editable by others than root.
sudo chmod 440 /etc/sudoers.d/astra-airlock-sync
