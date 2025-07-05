{
  pkgs,
  lib,
  greeter,
  assets,
  distroName ? "NixOS",
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    ./iso.nix
    ./home.nix
  ];

  system.nixos.distroName = distroName;
  networking.hostName = builtins.replaceStrings [ " " ] [ "" ] distroName;
  users.users.root.initialHashedPassword = lib.mkForce "";

  services.displayManager.sddm.enable = false;
  services.greetd = {
    enable = true;
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
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    xdgOpenUsePortal = true;
  };

  programs.uwsm.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;

  fonts.packages = with pkgs; [
    mplus-outline-fonts.githubRelease
  ];

  system.stateVersion = "24.05";
}
