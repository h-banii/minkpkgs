{ minkpkgs, ... }@moduleArgs:
with minkpkgs.lib;
{
  lib,
  config,
  pkgs,
  ...
}:
let
  _cfg = module.getConfig moduleArgs config;
in
{
  imports = [
    (module.import moduleArgs "obs-studio.nix")
  ];
}
