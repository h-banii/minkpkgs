{
  assets,
  minkpkgs,
  pkgs,
  ...
}:
{
  isoImage.edition = "graphical";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    minkpkgs.nixosModules.default
    (import ../common/iso.nix "graphical-base")
  ];

  environment = {
    systemPackages = with pkgs; [
      libsForQt5.kpmcore
      calamares-nixos
      calamares-nixos-extensions
      glibcLocales
      foot
      hyprland
    ];

    pathsToLink = [
      "/share/calamares"
    ];
  };

  services.greetd =
    let
      hyprlandConfig = pkgs.writeText "hyprland-greeter.conf" ''
        monitor=,preferred,auto,1
        exec-once = calamares
        decoration {
          screen_shader = ${assets.shader}
        }
        $mod = SUPER;
        bind = $mod, Enter, exec, calamares
        bind = $mod, T, exec, foot
        bind = $mod, C, killactive
        bindm = $mod, mouse:272, movewindow
        bindm = $mod, mouse:273, resizewindow
      '';
    in
    {
      enable = true;
      settings = {
        default_session = {
          user = "nixos";
          command = "Hyprland --config ${hyprlandConfig}";
        };
      };
    };

  mikanos = {
    system.branding.enable = true;
  };
}
