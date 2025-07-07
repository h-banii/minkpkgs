{ minkpkgs, ... }@moduleArgs:
with minkpkgs.lib;
{ lib, config, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkDefault
    ;
  cfg = module.getConfig moduleArgs config;
  supercfg = module.getSuperConfig moduleArgs config;
  withUWSM = supercfg.uwsm.enable;
in
{
  options = module.setOptions moduleArgs {
    enable = mkEnableOption "Hyprland";
  };

  config = mkIf cfg.enable {
    programs.hyprland.enable = true;
    # TODO: Set custom config here
    # programs.uwsm.waylandCompositors.hyprland-mikan = {
    #   prettyName = "Hyprland";
    #   comment = "Hyprland compositor managed by UWSM";
    #   binPath = "/run/current-system/sw/bin/Hyprland";
    # };
    programs.hyprland.withUWSM = mkDefault withUWSM;
  };
}
