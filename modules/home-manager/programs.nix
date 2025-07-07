{ minkpkgs, ... }@moduleArgs:
with minkpkgs.lib;
{ lib, config, ... }:
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
      obs-studio.plugins = mkOption {
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
