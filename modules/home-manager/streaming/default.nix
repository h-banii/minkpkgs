{ minkpkgs, ... }@moduleArgs:
with minkpkgs.lib;
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkDefault
    mkEnableOption
    ;
  cfg = module.getConfig moduleArgs config;
in
{
  imports = [
    (module.import moduleArgs "obs-studio.nix")
  ];

  options = module.setOptions moduleArgs {
    enable = mkEnableOption null // {
      description = ''
        Whether to enable default streaming programs:
        - obs-studio
      '';
    };
  };

  config = mkIf cfg.enable (
    module.setOptions moduleArgs {
      obs-studio.enable = mkDefault true;
    }
  );
}
