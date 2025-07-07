{
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    ./iso.nix
    ./home.nix
  ];

  linuxMink = {
    setDistroName = true;
    greeter.enable = true;
    display.wayland = {
      uwsm.enable = true;
      hyprland.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
