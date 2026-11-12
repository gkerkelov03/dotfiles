#!/usr/bin/env bash
set -euo pipefail

options=(
  --connect "qemu:///system" # the connection virt-manager uses
  --name "arch2"             # VM name shown in virt-manager
  --osinfo "archlinux"       # lets virt-install pick good defaults for Arch
  --memory "8192"            # RAM in MB (8 GB)
  --vcpus "8"                # CPU cores

  --boot "uefi,firmware.feature0.name=secure-boot,firmware.feature0.enabled=no,firmware.feature1.name=enrolled-keys,firmware.feature1.enabled=no"
  # ^ UEFI firmware with Secure Boot turned off

  --disk "size=200,format=qcow2,bus=virtio"  # 200 GB disk; qcow2 grows as needed and supports snapshots
  --cdrom "/var/lib/libvirt/images/arch.iso" # Arch ISO to boot the installer from
  --noautoconsole                            # don't open a console window; use virt-manager instead
)

sudo virt-install "${options[@]}"
