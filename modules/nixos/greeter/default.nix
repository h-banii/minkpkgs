{ minkpkgs, ... }@moduleArgs:
with minkpkgs.lib;
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
  system = pkgs.stdenv.hostPlatform.system;
  inherit (minkpkgs.packages.${system}) greeter assets;
  cfg = module.getConfig moduleArgs config;
in
{
  options = module.setOptions moduleArgs {
    enable = mkEnableOption "custom greeter";
  };

  config = mkIf cfg.enable {
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
  };
}
