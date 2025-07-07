{
  modulePath,
  moduleLib,
  distroName,
  packages,
  ...
}@moduleArgs:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkMerge
    mkIf
    mkDefault
    mkEnableOption
    ;
  inherit (packages.${pkgs.stdenv.hostPlatform.system}) greeter assets;
  cfg = lib.getAttrFromPath modulePath config;
in
{
  imports = [
    (moduleLib.import ./display moduleArgs [ "display" ])
  ];

  options = lib.setAttrByPath modulePath {
    distroName.enable = mkEnableOption "distribution name";
    greeter.enable = mkEnableOption "${distroName} greeter";
  };

  config = mkMerge [
    (mkIf cfg.distroName.enable {
      system.nixos.distroName = mkDefault distroName;
      networking.hostName = mkDefault (builtins.replaceStrings [ " " ] [ "" ] distroName);
    })
    (mkIf cfg.greeter.enable {
      services.greetd = {
        enable = mkDefault true;
        settings = {
          default_session =
            let
              hyprlandConfig = pkgs.writeText "hyprland-greeter.conf" ''
                monitor=,preferred,auto,1
                exec-once = ${lib.getExe greeter}
                decoration {
                  screen_shader = ${assets.shader}
                }
              '';
            in
            {
              command = "Hyprland --config ${hyprlandConfig}";
            };
        };
      };
    })
  ];
}
