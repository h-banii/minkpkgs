{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    minkpkgs.url = "github:h-banii/minkpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      minkpkgs,
      ...
    }@inputs:
    let
      system = "${system}";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        # You can change 'mink-desktop' to whatever name you want
        # (e.g. mink-laptop, potato-pc, etc)
        mink-desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit minkpkgs inputs;
          };
          modules = [
            ./system/desktop
          ];
        };
      };

      formatter.${system} = pkgs.nixfmt-tree;
    };
}
