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
  };
  users.users.root.initialHashedPassword = lib.mkForce "";

  services.displayManager.sddm.enable = false;

  programs.uwsm.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;

  fonts.packages = with pkgs; [
    mplus-outline-fonts.githubRelease
  ];

  system.stateVersion = "24.05";
}
