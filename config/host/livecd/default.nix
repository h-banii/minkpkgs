{
  pkgs,
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

  fonts.packages = with pkgs; [
    mplus-outline-fonts.githubRelease
  ];

  system.stateVersion = "24.05";
}
