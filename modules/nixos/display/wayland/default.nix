{ modulePath, ... }@moduleArgs:
{ lib, config, ... }:
let
  inherit (lib) setAttrByPath mkEnableOption;
in
{
  imports = [
    (import ./hyprland.nix (
      moduleArgs
      // {
        modulePath = modulePath ++ [ "hyprland" ];
      }
    ))
  ];

  options = setAttrByPath modulePath {
    uwsm.enable = mkEnableOption "UWSM (Universal Wayland Session Manager)";
  };
}
