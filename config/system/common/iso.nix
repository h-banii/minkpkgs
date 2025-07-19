installer:
{
  lib,
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
  };
}
