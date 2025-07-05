# Nix

This project requires [nix](https://nixos.org/) with **flakes** enabled.

::: tip Recommended reads

- <https://wiki.archlinux.org/title/Nix#Installation>
- <https://wiki.nixos.org/wiki/Flakes#Setup>
:::

::: warning
Commands in this page were not tested (yet)
:::

## Install nix on non-NixOS distros

### From your package manager

::: details Arch

```sh
pacman -Syu nix
```

:::

### From nixos.org

```sh
curl --proto '=https' --tlsv1.2 -sSfL \
    https://nixos.org/nix/install -o nix-install.sh
```

Read the script before executing it

```sh
less nix-install.sh
```

Do the multi-user installation

```sh
./nix-install.sh --daemon
```

::: info Reference
<https://nixos.org/download/>
:::

## Enable `nix command` and `flakes`

Add this to `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`

```txt
experimental-features = nix-command flakes
```

You might need to restart the nix daemon for the configuration to take effect.
