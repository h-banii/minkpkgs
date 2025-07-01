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
      programs.kitty.enable = true;
      wayland.windowManager.hyprland.enable = true;
      wayland.windowManager.hyprland.settings = {
        "$mod" = "SUPER";
        monitor = [
          ",preferred,auto,1"
        ];
        bind = [
          "$mod, C, killactive"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
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
