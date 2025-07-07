{
  minkpkgs,
  distroName,
  ...
}@moduleArgs:
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
    programs.uwsm.enable = mkDefault withUWSM;
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = mkDefault withUWSM;
  };
}
