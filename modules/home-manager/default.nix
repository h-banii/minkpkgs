{
  inputs,
  minkpkgs,
  release,
  ...
}@initialModuleArgs:
with minkpkgs.lib;
{ pkgs, lib, ... }:
let
  homeManagerConfig = with lib; {
    home.stateVersion = mkDefault "24.05";
    home.username = mkDefault "user";
    home.homeDirectory = mkDefault "/home/user";
  };

  homeManagerModule =
    let
      hmPath = inputs.home-manager.outPath;
      extendedLib = import "${hmPath}/modules/lib/stdlib-extended.nix" lib;
    in
    import "${hmPath}/modules/default.nix" {
      configuration = homeManagerConfig;
      check = false;
      inherit pkgs;
      lib = extendedLib;
    };

  moduleArgs = initialModuleArgs // {
    modulePrefix = [ "mikanos" ];
    rootPath = ./.;
    modulePath = [ ];
    inherit homeManagerModule;
  };
in
{
  imports = [
    {
      config = homeManagerConfig;
    }
    (module.import moduleArgs "display/wayland/hyprland.nix")
    (module.import moduleArgs "programs")
    (module.import moduleArgs "streaming")
    (module.import moduleArgs "system")
  ];
}
