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
    mkIf
    mkOption
    mkDefault
    mkEnableOption
    ;
  cfg = module.getConfig moduleArgs config;
in
{
  options = module.setOptions moduleArgs {
    enable = mkEnableOption "default programs";
    startup = mkOption {
      description = "Startup programs";
      type = with lib.types; listOf str;
      default = [ ];
      example = lib.literalExpression ''[ "firefox https://example.com" "obs" ]'';
    };
  };

  config = mkIf cfg.enable (
    module.setOptions moduleArgs {
      streaming.enable = mkDefault true;
    }
  );
}
