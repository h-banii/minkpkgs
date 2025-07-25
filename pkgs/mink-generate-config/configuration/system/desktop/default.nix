{
  minkpkgs,
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    minkpkgs.nixosModules.default
    minkpkgs.inputs.home-manager.nixosModules.default
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  # Linux Mink system options
  # system-config #

  # System packages
  environment.systemPackages = with pkgs; [
    hello
  ];

  # Replace 'mikan' with your desired user name
  users = {
    users = {
      mikan = {
        # REPLACE
        isNormalUser = true;
        group = "mikan"; # REPLACE
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
        ];
      };
    };
    groups = {
      mikan = { }; # REPLACE
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "home-manager-backup";
    extraSpecialArgs = {
      inherit minkpkgs inputs;
      systemConfig = config;
    };
    users = {
      mikan = import ../../home/mikan; # REPLACE
    };
  };
}
