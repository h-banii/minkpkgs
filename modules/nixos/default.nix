{
  minkpkgs,
  distroName,
  ...
}@initialModuleArgs:
let
  moduleArgs = initialModuleArgs // {
    modulePrefix = [ "linuxMink" ];
    rootPath = ./.;
    modulePath = [ ];
  };
in
with minkpkgs.lib;
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkMerge
    mkIf
    mkDefault
    mkEnableOption
    ;
  cfg = minkpkgs.lib.module.getConfig moduleArgs config;
in
{
  imports = [
    (module.import moduleArgs "display/wayland")
    (module.import moduleArgs "greeter")
  ];

  options = module.setOptions moduleArgs {
    setDistroName = mkEnableOption null // {
      description = "Whether to set distribution name to ${distroName}";
    };
  };

  config = mkMerge [
    (mkIf cfg.setDistroName {
      system.nixos.distroName = mkDefault distroName;
      networking.hostName = mkDefault (builtins.replaceStrings [ " " ] [ "" ] distroName);
    })
  ];
}
