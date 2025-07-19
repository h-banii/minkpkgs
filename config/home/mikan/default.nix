{ minkpkgs, ... }:
{
  home.stateVersion = "24.05";

  imports = [
    minkpkgs.homeManagerModules.default
  ];

  linuxMink = import ./mink.nix;

  programs.foot.enable = true;
  programs.firefox.enable = true;
}
