{
  minkpkgs,
  inputs,
  release,
  ...
}@moduleArgs:
with minkpkgs.lib;
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkMerge mkIf mkEnableOption;
  system = pkgs.stdenv.hostPlatform.system;
  cfg = module.getConfig moduleArgs config;
in
{
  options = module.setOptions moduleArgs {
    branding.enable = mkEnableOption null // {
      description = "Whether to set /etc/os-release";
    };
    install-tools = {
      enable = mkEnableOption null // {
        description = ''
          Whether to modify NixOS install tools (nixos-generate-config) to
          generate a custom initial configuration for ${release.distroName}.

          This is useful during installation.

          See nixos/modules/installer/tools/tools.nix
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.branding.enable {
      system.nixos = release;
    })
    (mkIf cfg.install-tools.enable {
      environment.systemPackages = [
        minkpkgs.packages.${system}.mink-install-tools
      ];
    })
  ];
}
