# Nix

This project requires [nix](https://nixos.org/) with **flakes** enabled.

::: tip Recommended reads

- <https://wiki.archlinux.org/title/Nix#Installation>
- <https://wiki.nixos.org/wiki/Flakes#Setup>
:::

## Install on non-NixOS distros

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

## Enable `nix command` and `flakes`

Add this to `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`

```txt
experimental-features = nix-command flakes
```

You might need to restart the nix daemon for the configuration to take effect.
