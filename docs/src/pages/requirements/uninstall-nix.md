# Uninstall Nix

```console
$ sudo rm -rf /nix
$ rm -rf ~/.nix-{channels,defexpr,profile}
$ rm -rf ~/.config/nix
```

Edit your `~/.profile` to remove the line that sources `nix.sh`
