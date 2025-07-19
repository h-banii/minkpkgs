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

  linuxMink = import ./mink.nix;
}
