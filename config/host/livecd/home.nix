{ inputs, assets, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.mikan = {
    isNormalUser = true;
    group = "mikan";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    initialHashedPassword = "";
  };
  users.groups.mikan = { };

  home-manager.users.mikan = import ../../home/mikan;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit assets;
    };
  };
}
