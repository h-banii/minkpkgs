{
  minkpkgs,
  inputs,
  release,
  ...
}@moduleArgs:
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
  inherit (minkpkgs.legacyPackages.${system}) assets;
  greeter = pkgs.callPackage ./package.nix {
    settings = {
      wallpaper = assets.wallpaper;
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      loading_icon = assets.logo;
      font-family = "M PLUS 2";
      sessions = [
        {
          name = "Hyprland";
          cmd = "uwsm start hyprland-uwsm.desktop";
        }
      ];
      vendor_name = release.distroName;
    };
    greeter-unwrapped = inputs.greeter.packages.${system}.default;
  };
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
    fonts.packages = with pkgs; [
      mplus-outline-fonts.githubRelease
    ];
  };
}
