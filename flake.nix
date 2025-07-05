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
      assetsFor = forAllSystems (system: self.packages.${system}.assets);
      distroName = "MikanOS";
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
          assets = pkgs.callPackage ./assets { };
        in
        {
          inherit assets;

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

          livecd =
            let
              inherit (self.lib.${system}) mkQemuIso;
              livecdSystem = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = {
                  inherit inputs distroName;
                  assets = assetsFor.${system};
                  greeter = self.packages.${system}.greeter;
                  isoWithCompression = true;
                };
                modules = [
                  ./host/livecd
                ];
              };
              iso = livecdSystem.config.system.build.isoImage;
            in
            {
              vm = livecdSystem.config.system.build.vm;
              inherit iso;
              iso-vm = mkQemuIso {
                inherit iso;
                withUefi = true;
              };
            };
        }
      );

      # TODO: Extend nixpkgs.lib
      lib = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          mkQemuIso =
            {
              iso,
              withUefi ? false,
            }:
            pkgs.writeShellScriptBin "qemu-system-x86_64-${distroName}" ''
              ${pkgs.qemu}/bin/qemu-system-x86_64 \
                ${if withUefi then "-bios ${pkgs.OVMF.fd}/FV/OVMF.fd" else ""} \
                -cdrom $(echo ${iso}/iso/*.iso) \
                $QEMU_OPTS \
                "$@"
            '';
        }
      );
    };
}
