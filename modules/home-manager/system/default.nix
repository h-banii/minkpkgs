{ minkpkgs, homeManagerModule, ... }@moduleArgs:
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
    mkMerge
    mkEnableOption
    literalExpression
    ;
  system = pkgs.stdenv.hostPlatform.system;
  inherit (minkpkgs.legacyPackages.${system}) assets;
  cfg = module.getConfig moduleArgs config;
in
{
  options = module.setOptions moduleArgs {
    fetch = {
      fastfetch = {
        enable = mkEnableOption "Whether to enable fastfetch";
        settings = homeManagerModule.options.programs.fastfetch.settings // {
          description = "Fastfetch settings";
          example = literalExpression ''
            {
              display = {
                size = {
                  binaryPrefix = "si";
                };
                color = "blue";
                separator = "  ";
              };
              modules = [
                {
                  type = "datetime";
                  key = "Date";
                  format = "{1}-{3}-{11}";
                }
                {
                  type = "datetime";
                  key = "Time";
                  format = "{14}:{17}:{20}";
                }
                "break"
                "player"
                "media"
              ];
            }
          '';
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.fetch.fastfetch.enable {
      programs.fastfetch = {
        enable = cfg.fetch.fastfetch.enable;
        settings = lib.recursiveUpdate {
          logo = {
            type = "file";
            source = assets.ascii-logo;
          };
          modules = [
            "title"
            "separator"
            "os"
            "host"
            "kernel"
            "uptime"
            "packages"
            "shell"
            "display"
            "de"
            "wm"
            "wmtheme"
            "theme"
            "icons"
            "font"
            "cursor"
            "terminal"
            "terminalfont"
            "cpu"
            "gpu"
            "memory"
            "swap"
            "disk"
            "localip"
            "battery"
            "poweradapter"
            "locale"
            "break"
            "colors"
          ];
        } cfg.fetch.fastfetch.settings;
      };
    })
  ];
}
