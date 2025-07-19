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
  system = pkgs.stdenv.hostPlatform.system;
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
          default = ''{ # System Options }'';
          type = lib.types.str;
        };
        home = mkOption {
          description = "Default ${release.distroName} home configuration";
          default = ''{ # Home Options }'';
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
              minkpkgs.url = "github:h-banii/LinuxMink";
            };

            outputs = { self, nixpkgs, minkpkgs, ... }\@inputs: let
              system = "${system}";
              pkgs = nixpkgs.legacyPackages.${system};
            in {
              nixosConfigurations.${config.networking.hostName} = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = {
                  inherit minkpkgs inputs;
                };
                modules = [
                  minkpkgs.nixosModules.default
                  minkpkgs.inputs.home-manager.nixosModules.default

                  # System configuration
                  {
                    ${base} = ${cfg.installer.configuration.system};

                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      backupFileExtension = "home-manager-bak";
                      extraSpecialArgs = {
                        inherit minkpkgs inputs;
                      };
                    };
                  }

                  # User configuration
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

                    home-manager.users.mikan = {
                      # Home configuration for the mikan user
                      ${base} = ${cfg.installer.configuration.home};
                    };
                  }
                  ./configuration.nix
                ];
              };

              formatter.\''${system} = pkgs.nixfmt-tree;
            };
          }
        '';
      };
    })
  ];
}
