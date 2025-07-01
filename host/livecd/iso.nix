{
  lib,
  isoWithCompression ? true,
  distroName,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")
  ];

  isoImage =
    let
      splashImage = pkgs.fetchurl {
        url = "https://yt3.googleusercontent.com/RIWEh-tuhMXXExCZ3_BKK0u0lw9GAek4SZk_sMxQksk_utddEBuf-4BUDC8ORScsbnuk6VQ4dA=s720-c-k-c0x00ffffff-no-rj";
        hash = "";
      };
    in
    {
      appendToMenuLabel = "";
      isoBaseName = distroName;
      inherit splashImage;
      efiSplashImage = splashImage;
      grubTheme = null;
      squashfsCompression = lib.mkIf (isoWithCompression == false) "gzip -Xcompression-level 1";
    };
}
