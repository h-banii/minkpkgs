{
  lib,
  isoWithCompression ? true,
  distroName,
  modulesPath,
  assets,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")
  ];

  isoImage = {
    appendToMenuLabel = "";
    isoBaseName = lib.mkForce (builtins.replaceStrings [ " " ] [ "" ] distroName);
    splashImage = assets.logo;
    efiSplashImage = assets.wallpaper;
    grubTheme = null;
    squashfsCompression = lib.mkIf (isoWithCompression == false) "gzip -Xcompression-level 1";
  };
}
