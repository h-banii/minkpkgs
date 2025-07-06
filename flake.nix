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
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
          assets = assetsFor.${system};
        in
        {
          greeter =
            let
              config = pkgs.writeText "h-banii.greeter-config" (
                builtins.toJSON {
                  wallpaper = assets.wallpaper;
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  loading_icon = assets.logo;
                  font-family = "M PLUS 2";
                  sessions = [
                    {
                      name = "Hyprland";
                      cmd = "uwsm start hyprland-uwsm.desktop";
                    }
                  ];
                  vendor_name = distroName;
                }
              );
              greeter = lib.getExe inputs.greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
            in
            pkgs.writeShellScriptBin "greeterWrapped" ''
              export H_BANII_GREET_CONFIG=${config} # TODO: Use wrapProgram
              exec ${greeter}
            '';
          docs = inputs.docs.packages.${system}.default;
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
              inherit inputs distroName assets;
              isoWithCompression = false;
            };
            modules = [
              self.nixosModules.default
              ./host/livecd
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
          inherit assets;
        }
      );

      nixosModules.default = import ./host/module {
        module = "linuxMink";
        packages = forAllSystems (system: self.packages.${system} // self.legacyPackages.${system});
        inherit distroName;
      };

      lib = {
        mkIsoVm =
          {
            writeShellScriptBin,
            qemu,
            OVMF,
            iso,
            withUefi ? false,
          }:
          writeShellScriptBin "qemu-system-x86_64-${distroName}" ''
            ${qemu}/bin/qemu-system-x86_64 \
              ${if withUefi then "-bios ${OVMF.fd}/FV/OVMF.fd" else ""} \
              -cdrom $(echo ${iso}/iso/*.iso) \
              $QEMU_OPTS \
              "$@"
          '';
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
