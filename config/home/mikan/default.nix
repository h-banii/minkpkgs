{ minkpkgs, pkgs, ... }:
{
  home.stateVersion = "24.05";

  imports = [
    minkpkgs.homeManagerModules.default
  ];

  linuxMink = {
    programs = {
      enable = true;
      startup = [
        "firefox https://denchisoft.com/"
        "obs"
      ];
    };
    display.wayland.hyprland = {
      enable = true;
      config = {
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
      };
    };
    display.wayland.hyprland.hyprpaper.enable = true;
  };

  home.packages = with pkgs; [
    foot
  ];

  programs.firefox.enable = true;
}
