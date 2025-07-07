{
  pkgs,
  lib,
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
    distroName.enable = true;
    greeter.enable = true;
    display.wayland = {
      uwsm.enable = true;
      hyprland.enable = true;
    };
  };
  users.users.root.initialHashedPassword = lib.mkForce "";

  services.displayManager.sddm.enable = false;

  fonts.packages = with pkgs; [
    mplus-outline-fonts.githubRelease
  ];

  system.stateVersion = "24.05";
}
