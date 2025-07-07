{ modulePath, moduleLib, ... }@moduleArgs:
{ lib, config, ... }:
let
  inherit (lib) setAttrByPath mkEnableOption;
in
{
  imports = [
    (moduleLib.import ./hyprland.nix moduleArgs [ "hyprland" ])
  ];

  options = setAttrByPath modulePath {
    uwsm.enable = mkEnableOption "UWSM (Universal Wayland Session Manager)";
  };
}
