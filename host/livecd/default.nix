{
  pkgs,
  lib,
  greeter,
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
  networking.hostName = distroName;
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
          '';
        in
        {
          command = "Hyprland --config ${hyprlandConfig}";
        };
    };
  };

  programs.uwsm.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  environment.systemPackages = with pkgs; [
    foot
  ];

  fonts.packages = with pkgs; [
    mplus-outline-fonts.githubRelease
  ];

  system.stateVersion = "24.05";
}
