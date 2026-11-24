# Setup

## 1. Install Arch Linux

Boot from the live USB, then connect to Wi-Fi. Replace `wlan0` if `device list` shows a different name:

```bash
iwctl device list
iwctl station wlan0 scan
iwctl station wlan0 get-networks
iwctl station wlan0 connect "WiFiName"
iwctl station wlan0 show
```

Run the installer:

```bash
archinstall --config-url https://gkerkelov03.com/archinstall-helper
```

> [!WARNING]
> When the installation finishes, reboot and remove the USB.
> Do not chroot into the new environment.

## 2. Get the dotfiles

```bash
git clone https://gitlab.com/kerkelov/dotfiles ~/dotfiles
```

## 3. Run install-all-packages.sh

```bash
bash ~/dotfiles/scripts/install-all-packages.sh
```

> [!WARNING]
> If there are packages that failed to install you should install them manually.

## 4. Run reproduce.sh

```bash
bash ~/dotfiles/scripts/reproduce.sh
```
