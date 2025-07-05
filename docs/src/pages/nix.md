# Nix

This project requires [nix](https://nixos.org/) with the experimental
**flakes** feature enabled.

::: tip Recommended reads

- <https://wiki.archlinux.org/title/Nix#Installation>
- <https://wiki.nixos.org/wiki/Flakes#Setup>
- <https://nixos.org/download/>
:::

::: info Commands tested on

- Ubuntu Server 25.04
:::

## Installation

### From your package manager

::: details Arch

```sh
pacman -Syu nix
```

:::

### From installer

::: details nixos.org

Fetch the installer

```sh
curl --proto '=https' --tlsv1.2 -sSfL \
    https://nixos.org/nix/install -o nix-install.sh
```

Read the script before executing it

```sh
less nix-install.sh
```

Give execute permission

```sh
chmod +x nix-install.sh
```

Do the installation (single-user)

```sh
./nix-install.sh --no-daemon
```

Source this file to update your PATH (or just open a new terminal)

```sh
. ~/.nix-profile/etc/profile.d/nix.sh
```

:::

## Enable experimental features

Add this to `~/.config/nix/nix.conf`

```txt
experimental-features = nix-command flakes
```

```console
$ mkdir -p ~/.config/nix
$ echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

## Check

If everything went right, this should work

```console
$ nix run nixpkgs#hello
Hello, world!
```
