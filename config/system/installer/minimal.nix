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
    (import ../common/iso.nix "minimal")
    ./config.nix
  ];

  linuxMink = {
    modifyOSRelease = true;
  };
}
