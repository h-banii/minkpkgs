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
    mkMerge
    mkDefault
    mkEnableOption
    literalExpression
    types
    ;
  cfg = module.getConfig moduleArgs config;
in
{
  options = module.setOptions moduleArgs {
    enable = mkEnableOption "default programs";
    obs-studio = {
      enable = mkEnableOption "OBS (Open Broadcaster Software)";
      plugins = mkOption {
        default = [ ];
        example = literalExpression "[ pkgs.obs-studio-plugins.wlrobs ]";
        description = "Optional OBS plugins.";
        type = with types; listOf package;
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable (
      module.setOptions moduleArgs {
        obs-studio.enable = mkDefault true;
      }
    ))
    (mkIf cfg.obs-studio.enable {
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
          ++ cfg.obs-studio.plugins
        );
      };
    })
  ];
}
