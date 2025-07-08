{
  minkpkgs,
  release,
  ...
}@moduleArgs:
with minkpkgs.lib;
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption;
  system = pkgs.stdenv.hostPlatform.system;
  inherit (minkpkgs.legacyPackages.${system}) assets;
  cfg = module.getConfig moduleArgs config;
in
{
  options = module.setOptions moduleArgs {
    enable = mkEnableOption "Hyprland config";
    hyprpaper.enable = mkEnableOption "Hyprpaper (wallpaper)";
    # TODO: Extra config
  };

  config = {
    wayland.windowManager.hyprland.enable = cfg.enable;
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      monitor = [
        ",preferred,auto,1"
      ];
      bind = [
        "$mod, C, killactive"
        "$mod, T, exec, foot"
        "$mod, O, exec, obs-studio"
        "$mod, V, exec, firefox https://denchisoft.com/"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      windowrule = [
        "fullscreenstate -1 2, class:firefox"
      ];
      exec-once = [
        "firefox https://denchisoft.com/"
        "obs"
      ];
      general = {
        gaps_in = 8;
        gaps_out = 8;
        border_size = 3;
        col.active_border = "0xFFA500FF";
      };
      decoration = {
        rounding = 10;
        screen_shader = "${assets.shader}";
        active_opacity = 0.95;
        inactive_opacity = 0.85;
        fullscreen_opacity = 1.00;
      };
    };

    services.hyprpaper = {
      enable = cfg.hyprpaper.enable;
      settings = {
        preload = [ "${assets.wallpaper}" ];
        wallpaper = [
          ",${assets.wallpaper}"
        ];
      };
    };
  };
}
