installer:
{
  lib,
  release,
  modulesPath,
  assets,
  pkgs,
  config,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-${installer}.nix")
  ];

  isoImage = {
    appendToMenuLabel = "";
    isoBaseName = "${release.distroId}${
      lib.optionalString (config.isoImage.edition != "") "-${config.isoImage.edition}"
    }-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
    splashImage = assets.logo;
    efiSplashImage = assets.wallpaper;
    grubTheme = null;
  };
}
