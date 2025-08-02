{ minkpkgs, ... }@moduleArgs:
with minkpkgs.lib;
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    ;
  _cfg = module.getConfig moduleArgs config;
in
{
  options = module.setOptions moduleArgs {
    startup = mkOption {
      description = "Startup programs";
      type = with lib.types; listOf str;
      default = [ ];
      example = lib.literalExpression ''[ "firefox https://example.com" "obs" ]'';
    };
  };
}
