{
  minkpkgs,
  distroName,
  ...
}@moduleArgs:
{ lib, config, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkDefault
    ;
  cfg = minkpkgs.lib.module.getConfig moduleArgs config;
  supercfg = minkpkgs.lib.module.getSuperConfig moduleArgs config;
  withUWSM = supercfg.uwsm.enable;
in
{
  options = minkpkgs.lib.module.setOptions moduleArgs {
    enable = mkEnableOption "Hyprland";
  };

  config = mkIf cfg.enable {
    programs.uwsm.enable = mkDefault withUWSM;
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = mkDefault withUWSM;
  };
}
