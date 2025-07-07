{
  modulePath,
  distroName,
  supercfg,
  ...
}:
{ lib, config, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkDefault
    ;
  cfg = lib.getAttrFromPath modulePath config;
  withUWSM = supercfg.uwsm.enable;
in
{
  options = lib.setAttrByPath modulePath {
    enable = mkEnableOption "Hyprland";
  };

  config = mkIf cfg.enable {
    programs.uwsm.enable = mkDefault withUWSM;
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = mkDefault withUWSM;
  };
}
