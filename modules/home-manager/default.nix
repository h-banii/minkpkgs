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
{ ... }:
{
  imports = [
    (module.import moduleArgs "programs.nix")
    (module.import moduleArgs "display/wayland/hyprland.nix")
  ];
}
