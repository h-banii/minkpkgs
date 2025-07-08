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
    mkOption
    mkDefault
    mkEnableOption
    literalExpression
    types
    ;
  cfg = module.getConfig moduleArgs config;
in
{
  options = module.setOptions moduleArgs {
    enable = mkEnableOption "OBS (Open Broadcaster Software)";
    plugins = mkOption {
      default = [ ];
      example = literalExpression "[ pkgs.obs-studio-plugins.wlrobs ]";
      description = "Optional OBS plugins.";
      type = with types; listOf package;
    };
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = mkDefault (
        with pkgs.obs-studio-plugins;
        [
          wlrobs
          obs-pipewire-audio-capture
          obs-vaapi
          obs-vkcapture
        ]
        ++ cfg.plugins
      );
    };
  };
}
