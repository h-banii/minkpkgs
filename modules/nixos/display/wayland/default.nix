{ minkpkgs, ... }@moduleArgs:
{ lib, config, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    (minkpkgs.lib.module.import moduleArgs "hyprland.nix")
  ];

  options = minkpkgs.lib.module.setOptions moduleArgs {
    uwsm.enable = mkEnableOption "UWSM (Universal Wayland Session Manager)";
  };
}
