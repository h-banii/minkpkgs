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
    mkMerge
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
    modifyInstallTools = mkEnableOption null // {
      description = ''
        Whether to modify NixOS install tools (nixos-generate-config)

        Useful in installation medias to generate a custom initial
        configuration for ${release.distroName}.

        See nixos/modules/installer/tools/tools.nix
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.modifyOSRelease {
      system.nixos = release;
    })
    (mkIf cfg.modifyInstallTools {
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
