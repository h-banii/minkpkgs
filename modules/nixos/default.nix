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
let
  inherit (lib)
    mkIf
    mkMerge
    mkOption
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
    modifyOSRelease = mkEnableOption null // {
      description = "Whether to modify /etc/os-release";
    };
    installer = {
      enable = mkEnableOption null // {
        description = ''
          Whether to modify NixOS install tools (nixos-generate-config) to
          generate a custom initial configuration for ${release.distroName}.

          This is useful during installation.

          See nixos/modules/installer/tools/tools.nix
        '';
      };
      config = mkOption {
        description = ''
          Default ${release.distroName} configuration installed by
          nixos-generate-config
        '';
        default = ''# Options'';
        type = lib.types.str;
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.modifyOSRelease {
      system.nixos = release;
    })
    (mkIf cfg.installer.enable {
      system.nixos-generate-config = {
        flake = ''
          {
            inputs = {
              nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
              minkpkgs.url = "github:h-banii/LinuxMink/stable";
            };

            outputs = { self, nixpkgs, minkpkgs, ... }: {
              nixosConfigurations.${config.networking.hostName} = nixpkgs.lib.nixosSystem {
                modules = [
                  minkpkgs.nixosModules.default
                  {
                    ${base} = {
                      ${cfg.installer.config}
                    };
                  }
                  ./configuration.nix
                ];
              };
            };
          }
        '';
      };
    })
  ];
}
