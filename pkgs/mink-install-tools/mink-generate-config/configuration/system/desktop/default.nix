{
  minkpkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    minkpkgs.nixosModules.default
    minkpkgs.inputs.home-manager.nixosModules.default
    ./configuration.nix
    ./hardware.nix
  ];

  # Linux Mink system options
  linuxMink = {
    # TODO: auto generate?
  };

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
