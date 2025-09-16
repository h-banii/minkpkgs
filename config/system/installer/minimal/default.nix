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
    (import ../../common/iso.nix "minimal")
  ];

  isoImage.edition = "minimal";

  linuxMink = {
    modifyOSRelease = true;
    system.install-tools.enable = true;
  };
}
