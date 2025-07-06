{
  module,
  distroName,
}:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkDefault
    mkEnableOption
    ;
  cfg = config.${module};
in
{
  options.${module} = {
    distroName.enable = mkEnableOption "distribution name";
  };

  config = mkIf cfg.distroName.enable {
    system.nixos.distroName = mkDefault distroName;
    networking.hostName = mkDefault (builtins.replaceStrings [ " " ] [ "" ] distroName);
  };
}
