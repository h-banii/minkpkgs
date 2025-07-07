{ modulePath, moduleLib, ... }@moduleArgs:
{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    (moduleLib.import moduleArgs "hyprland.nix")
  ];

  options = moduleLib.setOptions moduleArgs {
    uwsm.enable = mkEnableOption "UWSM (Universal Wayland Session Manager)";
  };
}
