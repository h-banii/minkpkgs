{
  moduleLib,
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
  cfg = moduleLib.getConfig moduleArgs config;
  supercfg = moduleLib.getSuperConfig moduleArgs config;
  withUWSM = supercfg.uwsm.enable;
in
{
  options = moduleLib.setOptions moduleArgs {
    enable = mkEnableOption "Hyprland";
  };

  config = mkIf cfg.enable {
    programs.uwsm.enable = mkDefault withUWSM;
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = mkDefault withUWSM;
  };
}
