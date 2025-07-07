{ minkpkgs, ... }@moduleArgs:
with minkpkgs.lib;
{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault mkEnableOption;
  cfg = module.getConfig moduleArgs config;
in
{
  imports = [
    (module.import moduleArgs "hyprland.nix")
  ];

  options = module.setOptions moduleArgs {
    uwsm.enable = mkEnableOption "UWSM (Universal Wayland Session Manager)";
  };

  config = mkIf cfg.uwsm.enable {
    programs.uwsm.enable = mkDefault true;
  };
}
