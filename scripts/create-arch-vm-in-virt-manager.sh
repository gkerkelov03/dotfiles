#!/usr/bin/env bash
set -euo pipefail # stop on any error, on unset variables, and on failures inside pipes

VM_NAME="arch" # VM name shown in virt-manager
CPUS=8         # logical CPU cores
RAM_MB=8192    # RAM in MB
DISK_GB=200    # disk size in GB (grows as needed, doesn't use it all up front)

options=(
  --connect "qemu:///system" # the connection virt-manager uses
  --name "$VM_NAME"          # VM name shown in virt-manager
  --osinfo "archlinux"       # lets virt-install pick good defaults for Arch
  --memory "$RAM_MB"         # RAM in MB
  --vcpus "$CPUS"            # CPU cores
  --boot "uefi,firmware.feature0.name=secure-boot,firmware.feature0.enabled=no,firmware.feature1.name=enrolled-keys,firmware.feature1.enabled=no"
  # ^ UEFI firmware with Secure Boot turned off
  --disk "size=$DISK_GB,format=qcow2,bus=virtio,boot.order=1"
  # ^ qcow2 disk (supports snapshots), booted first
  --disk "path=/var/lib/libvirt/images/arch.iso,device=cdrom,boot.order=2"
  # ^ Arch ISO as a CD drive; booted while the disk is still empty
  --import        # use these drives as-is, no special first-boot setup
  --noautoconsole # don't open a console window and don't wait
)

sudo virt-install "${options[@]}"

# virt-install always starts the VM; turn it off right away so it isn't running unnoticed
sudo virsh --connect qemu:///system destroy "$VM_NAME"
