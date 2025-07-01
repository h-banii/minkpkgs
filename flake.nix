{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    greeter = {
      url = "git+ssh://git@github.com/h-banii/greeter-dots.git";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      distroName = "MikanOS";
    in
    {
      packages.${system} = {
        greeter =
          let
            config = pkgs.writeText "h-banii.greeter-config" (
              builtins.toJSON {
                wallpaper = self.assets.wallpaper;
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                loading_icon = self.assets.logo;
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

      };

      # TODO: Separate livecd and default system configs
      # (I don't think anyone would use it)
      livecd =
        let
          livecdSystem = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit inputs distroName;
              assets = self.assets;
              greeter = self.packages.${system}.greeter;
              # isoWithCompression = false; # for faster build, but bigger iso
            };
            modules = [
              ./host/livecd
            ];
          };
        in
        {
          vm = livecdSystem.config.system.build.vm;
          iso = livecdSystem.config.system.build.isoImage;
        };

      assets = pkgs.callPackage ./assets { };
    };
}
