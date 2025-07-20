{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    greeter = {
      url = "github:h-banii/astal-greeter";
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/25.05";
    };
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
      release = {
        distroName = "Linux Mink";
        distroId = "linux-mink";
      };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
          nixosOptionsJSON = self.legacyPackages.${system}.nixosOptionsDoc.optionsJSON;
          homeManagerOptionsJSON = self.legacyPackages.${system}.homeManagerOptionsDoc.optionsJSON;
          docs-flake = (import ./docs/flake.nix).outputs {
            inherit nixpkgs;
            inherit systems;
          };
        in
        {
          docs = pkgs.symlinkJoin {
            name = "mikan-docs";
            paths = [
              docs-flake.packages.${system}.default
              (pkgs.linkFarm "mikan-modules-docs" [
                {
                  name = "nixos-options.json";
                  path = "${nixosOptionsJSON}/share/doc/nixos/options.json";
                }
                {
                  name = "home-manager-options.json";
                  path = "${homeManagerOptionsJSON}/share/doc/nixos/options.json";
                }
              ])
            ];
          };
        }
        // pkgs.callPackage ./pkgs {
          inherit system;
          minkpkgs = self;
        }
      );

      legacyPackages = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
          assets = assetsFor.${system};
          livecdSystem = lib.nixosSystem {
            inherit system;
            specialArgs = {
              minkpkgs = self;
              inherit inputs release assets;
            };
            modules = [
              ./config/system/livecd
            ];
          };
          minimalInstallerSystem = lib.nixosSystem {
            inherit system;
            specialArgs = {
              minkpkgs = self;
              inherit inputs release assets;
            };
            modules = [
              ./config/system/installer/minimal
            ];
          };
          graphicalInstallerSystem = lib.nixosSystem {
            inherit system;
            specialArgs = {
              minkpkgs = self;
              inherit inputs release assets;
            };
            modules = [
              ./config/system/installer/graphical.nix
            ];
          };
        in
        {
          livecd = livecdSystem.config.system.build // {
            isoVm = pkgs.callPackage self.lib.mkIsoVm {
              iso = self.legacyPackages.${system}.livecd.isoImage;
              withUefi = true;
            };
          };
          installer = {
            minimal = minimalInstallerSystem.config.system.build;
            graphical = graphicalInstallerSystem.config.system.build;
          };
          dotfiles = {
            hyprland = pkgs.callPackage self.lib.hm.mkDotfiles.hyprland {
              config = livecdSystem.config.home-manager.users.mikan;
            };
          };
          nixosOptionsDoc =
            let
              eval = self.lib.evalModuleWithoutCheck {
                module = self.nixosModules.default;
              };
            in
            pkgs.nixosOptionsDoc {
              inherit (eval) options;
            };
          homeManagerOptionsDoc =
            let
              eval = self.lib.evalModuleWithoutCheck {
                module = self.homeManagerModules.default;
                args = { inherit pkgs; };
              };
            in
            pkgs.nixosOptionsDoc {
              inherit (eval) options;
            };
          inherit assets;
        }
      );

      nixosModules.default = import ./modules/nixos {
        minkpkgs = self;
        inherit release inputs;
      };

      homeManagerModules.default = import ./modules/home-manager {
        minkpkgs = self;
        inherit release inputs;
      };

      lib = import ./lib {
        inherit lib release;
        hmLib = inputs.home-manager.lib.hm;
      };

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
