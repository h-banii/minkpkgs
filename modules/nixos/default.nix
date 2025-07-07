{
  minkpkgs,
  distroName,
  ...
}@initialModuleArgs:
let
  moduleArgs = initialModuleArgs // {
    modulePrefix =  [ "linuxMink" ];
    rootPath = ./.;
    modulePath = [ ];
  };
in
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
  system = pkgs.stdenv.hostPlatform.system;
  inherit (minkpkgs.packages.${system}) greeter assets;
  cfg = minkpkgs.lib.module.getConfig moduleArgs config;
in
{
  imports = [
    (minkpkgs.lib.module.import moduleArgs "display/wayland")
  ];

  options = minkpkgs.lib.module.setOptions moduleArgs {
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
