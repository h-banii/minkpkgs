# MikanOS (WIP)

NixOS configuration files for MikanOS.

https://github.com/user-attachments/assets/8faacc68-b6c7-47a0-92ca-e75077e7fb54

## Requirements

This project requires [nix](https://nixos.org/) with **flakes** enabled.

### Install nix on non-NixOS distros

> [!IMPORTANT]
> Read https://wiki.archlinux.org/title/Nix#Installation

Use your package manager

```sh
pacman -Syu nix
```

Or install from nixos.org

```sh
curl --proto '=https' --tlsv1.2 -sSfL https://nixos.org/nix/install -o nix-install.sh
less nix-install.sh         # read the script before executing it
./nix-install.sh --daemon   # multi-user installation
```

### Enable `nix command` and `flakes`

> [!IMPORTANT]
> Read https://wiki.nixos.org/wiki/Flakes#Setup

Add this to `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`

```txt
experimental-features = nix-command flakes
```

You might need to restart the nix daemon for the configuration to take effect.

## Outputs

```js
└─legacyPackages.system
  └─livecd
    ├─vm
    ├─isoImage
    └─isoVm
```

### Live CD (preview)

#### Virtual Machine (fast)

Run it in a virtual machine (qemu)

```console
$ export QEMU_OPTS='-m 4G -device virtio-vga-gl -display gtk,gl=on'
$ nix run github:h-banii/MikanOS#livecd.vm
```

#### ISO (slow)

Build the iso image

```sh
nix build github:h-banii/MikanOS#livecd.isoImage
```

Write .iso to usb stick (≥4GB)

```sh
dd bs=4M conv=fsync oflag=direct status=progress if=./result/iso/MikanOS.iso of=/dev/path-to-usb-flash-drive
```

> [!IMPORTANT]
> Make absolute sure you're writing to the right device
>
> `lsblk -o name,fstype,size,type,model,serial,mountpoint`

### Installer (WIP)

### NixOS Module (WIP)

### Home Manager Module (WIP)

## MikanTheMink

- https://www.youtube.com/@MikanTheMink
- https://www.twitch.tv/mikanthemink
- https://www.twitter.com/MikanTheMink
