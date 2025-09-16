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

  image = {
    baseName = lib.mkForce "${release.distroId}${
      lib.optionalString (config.isoImage.edition != "") "-${config.isoImage.edition}"
    }-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
  };

  isoImage = {
    appendToMenuLabel = "";
    splashImage = assets.logo;
    efiSplashImage = assets.wallpaper;
    grubTheme = null;
  };
}
