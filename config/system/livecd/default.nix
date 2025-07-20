{
  minkpkgs,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    minkpkgs.nixosModules.default
    (import ../common/iso.nix "graphical-base")
    ./home.nix
  ];

  isoImage.edition = "livecd";

  linuxMink = {
    modifyOSRelease = true;
    greeter.enable = true;
    display.wayland = {
      uwsm.enable = true;
      hyprland.enable = true;
    };
  };
}
