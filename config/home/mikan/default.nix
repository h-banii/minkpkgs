{ minkpkgs, pkgs, ... }:
{
  home.stateVersion = "24.05";

  imports = [
    minkpkgs.homeManagerModules.default
  ];

  linuxMink = {
    programs.enable = true;
    display.wayland.hyprland.enable = true;

    # TODO: Move this out of hyprland module
    display.wayland.hyprland.hyprpaper.enable = true;
  };

  home.packages = with pkgs; [
    foot
  ];

  programs.firefox.enable = true;
}
