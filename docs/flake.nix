{
  inputs = {
    minkpkgs.url = "path:../.";
    vue-nix-manual = {
      url = "github:h-banii/vue-nix-manual";
    };
  };

  outputs =
    {
      self,
      minkpkgs,
      vue-nix-manual,
      systems,
      ...
    }:
    let
      inherit (minkpkgs.inputs) nixpkgs;
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs (import systems);
      pkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        system:
        let
          inherit (minkpkgs.legacyPackages.${system}) homeManagerOptionsDoc nixosOptionsDoc;
        in
        {
          default = pkgsFor.${system}.callPackage ./nix/package.nix {
            vue-nix-manual = vue-nix-manual.packages.${system}.default;
            home-manager-options = homeManagerOptionsDoc.optionsJSON;
            nixos-options = nixosOptionsDoc.optionsJSON;
          };
        }
      );

      legacyPackages = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
          base = "minkpkgs";
        in
        {
          webserver = pkgs.symlinkJoin {
            name = "mikan-docs-webserver";
            meta.mainProgram = "http-server";
            nativeBuildInputs = [ pkgs.makeWrapper ];
            paths = with pkgs; [
              http-server
              (pkgs.linkFarm "" [
                {
                  name = "public/${base}";
                  path = self.packages.${system}.default;
                }
              ])
            ];
            postBuild = ''
              wrapProgram $out/bin/http-server \
                --add-flags "$out/public"
            '';
          };
        }
      );

      devShells = forAllSystems (system: {
        default = pkgsFor.${system}.callPackage ./nix/shell.nix { };
      });
    };
}
