{ modulePath, ... }@moduleArgs:
{ lib, config, ... }:
let
  inherit (lib) getAttrFromPath setAttrByPath mkEnableOption;
  cfg = getAttrFromPath modulePath config;
in
{
  imports = [
    (import ./hyprland.nix (
      moduleArgs
      // {
        modulePath = modulePath ++ [ "hyprland" ];
        supercfg = cfg;
      }
    ))
  ];

  options = setAttrByPath modulePath {
    uwsm.enable = mkEnableOption "UWSM (Universal Wayland Session Manager)";
  };
}
