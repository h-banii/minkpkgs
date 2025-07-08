{
  inputs,
  minkpkgs,
  release,
  ...
}@moduleArgs:
with minkpkgs.lib;
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption;
  system = pkgs.stdenv.hostPlatform.system;
  inherit (minkpkgs.legacyPackages.${system}) assets;
  cfg = module.getConfig moduleArgs config;
  hmModule =
    let
      hmPath = inputs.home-manager.outPath;
      extendedLib = import "${hmPath}/modules/lib/stdlib-extended.nix" lib;
    in
    import "${hmPath}/modules/services/window-managers/hyprland.nix" {
      inherit config pkgs;
      lib = extendedLib;
    };
in
{
  options = module.setOptions moduleArgs {
    enable = mkEnableOption "Hyprland config";
    hyprpaper.enable = mkEnableOption "Hyprpaper (wallpaper)";
    config = hmModule.options.wayland.windowManager.hyprland.settings // {
      description = "Hyprland configuration using Nix\n\nSee https://wki.hypr.land/Configuring";
    };
  };

  config = {
    wayland.windowManager.hyprland.enable = cfg.enable;
    wayland.windowManager.hyprland.settings = lib.recursiveUpdate {
      general = {
        gaps_in = 8;
        gaps_out = 8;
        border_size = 3;
        col.active_border = "0xFFA500FF";
      };
      decoration = {
        rounding = 10;
        screen_shader = "${assets.shader}"; # TODO: shader.orange.enable option
        active_opacity = 0.95;
        inactive_opacity = 0.85;
        fullscreen_opacity = 1.00;
      };
    } cfg.config;

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
