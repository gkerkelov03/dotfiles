#!/usr/bin/env bash
set -euo pipefail

#the service that updates the db of the locate command (plocate package)
sudo systemctl enable --now plocate-updatedb.timer

#the service that needs to be running so tools that expect docker can work with podman seamlessly
systemctl --user enable --now podman.socket

#the libvirt daemon that receives requests from tools like virt-manager and carries them out
sudo systemctl enable --now libvirtd
