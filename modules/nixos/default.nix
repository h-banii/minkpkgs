{
  minkpkgs,
  release,
  ...
}@initialModuleArgs:
let
  base = "linuxMink";
  moduleArgs = initialModuleArgs // {
    modulePrefix = [ base ];
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
{
  imports = [
    (module.import moduleArgs "display/wayland")
    (module.import moduleArgs "greeter")
    (module.import moduleArgs "system")
  ];
}
