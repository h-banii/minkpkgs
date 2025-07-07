{ minkpkgs, ... }@moduleArgs:
with minkpkgs.lib;
{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    (module.import moduleArgs "hyprland.nix")
  ];

  options = module.setOptions moduleArgs {
    uwsm.enable = mkEnableOption "UWSM (Universal Wayland Session Manager)";
  };
}
