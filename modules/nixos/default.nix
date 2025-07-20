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
    system = {
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
  };

  config = mkMerge [
    (mkIf cfg.modifyOSRelease {
      system.nixos = release;
    })
    (mkIf cfg.system.install-tools.enable {
      environment.systemPackages = [
        minkpkgs.packages.${system}.mink-install-tools
      ];
    })
  ];
}
