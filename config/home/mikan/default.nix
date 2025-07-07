{ minkpkgs, pkgs, ... }:
{
  home.stateVersion = "24.05";

  imports = [
    minkpkgs.homeManagerModules.default
    ./hyprland.nix
  ];

  linuxMink = {
    programs.enable = true;
  };

  home.packages = with pkgs; [
    foot
  ];

  programs.firefox.enable = true;
}
