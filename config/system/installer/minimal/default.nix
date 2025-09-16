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

  mikanos = {
    system.branding.enable = true;
    system.install-tools.enable = true;
  };
}
