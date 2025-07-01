{ inputs, assets, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.mikan = {
    isNormalUser = true;
    group = "mikan";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    initialHashedPassword = "";
  };
  users.groups.mikan = { };

  home-manager.users.mikan =
    { pkgs, ... }:
    {
      home.stateVersion = "24.05";

      home.packages = with pkgs; [
        foot
        firefox
        obs-studio
      ];

      wayland.windowManager.hyprland.enable = true;
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
          screen_shader = "${./shader.frag}";
        };
      };

      services.hyprpaper = {
        enable = true;
        settings = {
          preload = [ "${assets.wallpaper}" ];
          wallpaper = [
            ",${assets.wallpaper}"
          ];
        };
      };
    };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };
}
