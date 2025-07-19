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
      configuration = {
        system = mkOption {
          description = ''
            Default ${release.distroName} configuration installed by
            nixos-generate-config
          '';
          default = ''# System Options'';
          type = lib.types.str;
        };
        home = mkOption {
          description = "Default ${release.distroName} home configuration";
          default = ''# Home Options'';
          type = lib.types.str;
        };
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
              home-manager = {
                url = "github:nix-community/home-manager";
                inputs.nixpkgs.follows = "nixpkgs";
              };
            };

            outputs = { self, nixpkgs, minkpkgs, home-manager, ... }@inputs: {
              nixosConfigurations.${config.networking.hostName} = nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit minkpkgs inputs;
                };
                modules = [
                  minkpkgs.nixosModules.default
                  home-manager.nixosModules.default
                  {
                    ${base} = {
                      ${cfg.installer.configuration.system}
                    };
                  }
                  {
                    users.users.mikan = {
                      isNormalUser = true;
                      group = "mikan";
                      extraGroups = [
                        "wheel"
                        "networkmanager"
                        "video"
                      ];
                    };
                    users.groups.mikan = { };

                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      backupFileExtension = "home-manager-bak";
                      extraSpecialArgs = {
                        inherit minkpkgs inputs;
                      };
                      users.mikan = {
                        ${base} = {
                          ${cfg.installer.configuration.home}
                        };
                      };
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
