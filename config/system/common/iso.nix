installer:
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
    (modulesPath + "/installer/cd-dvd/installation-cd-${installer}.nix")
  ];

  isoImage = {
    appendToMenuLabel = "";
    isoBaseName = lib.mkForce release.distroId;
    splashImage = assets.logo;
    efiSplashImage = assets.wallpaper;
    grubTheme = null;
    squashfsCompression = lib.mkIf (!isoWithCompression) "gzip -Xcompression-level 1";
  };
}
