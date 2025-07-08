{
  lib,
  isoWithCompression ? true,
  release,
  modulesPath,
  assets,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")
  ];

  services.displayManager.sddm.enable = false;

  isoImage = {
    appendToMenuLabel = "";
    isoBaseName = lib.mkForce release.distroId;
    splashImage = assets.logo;
    efiSplashImage = assets.wallpaper;
    grubTheme = null;
    squashfsCompression = lib.mkIf (!isoWithCompression) "gzip -Xcompression-level 1";
  };
}
