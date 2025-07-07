{
  minkpkgs,
  release,
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
    mkIf
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
    setOSRelease = mkEnableOption null // {
      description = "Whether to set /etc/os-release";
    };
  };

  config = mkIf cfg.setOSRelease {
    system.nixos = release;
  };
}
