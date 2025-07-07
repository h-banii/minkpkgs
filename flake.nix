{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    greeter = {
      url = "github:h-banii/astal-greeter";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    docs.url = "path:docs";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs (import systems);
      pkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
      assetsFor = forAllSystems (system: pkgsFor.${system}.callPackage ./assets { });
      distroName = "Linux Mink";
    in
    {
      packages = forAllSystems (system: {
        docs = inputs.docs.packages.${system}.default;
      });

      legacyPackages = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
          assets = assetsFor.${system};
          livecdSystem = lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit inputs distroName assets;
              isoWithCompression = false;
            };
            modules = [
              self.nixosModules.default
              ./config/host/livecd
            ];
          };
        in
        {
          livecd = livecdSystem.config.system.build // {
            isoVm = pkgs.callPackage self.lib.mkIsoVm {
              iso = self.packages.${system}.livecd.isoImage;
              withUefi = true;
            };
          };
          nixosOptionsDoc = pkgs.nixosOptionsDoc {
            inherit (self.lib.evalModuleWithoutCheck self.nixosModules.default) options;
          };
          inherit assets;
        }
      );

      nixosModules.default = import ./modules/nixos {
        minkpkgs = self;
        inherit distroName inputs;
      };

      lib = import ./lib { inherit lib distroName; };

      checks = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
          assets = assetsFor.${system};
        in
        {
          shader =
            pkgs.runCommandLocal "mikan-check-shader"
              {
                nativeBuildInputs = [ pkgs.glslang ];
              }
              ''
                glslangValidator ${assets.shader} >$out
              '';
        }
      );

      formatter = forAllSystems (system: pkgsFor.${system}.nixfmt-tree);
    };
}
