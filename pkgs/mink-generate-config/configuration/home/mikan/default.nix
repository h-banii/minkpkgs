{
  minkpkgs,
  pkgs,
  systemConfig,
  ...
}:
{
  imports = [
    minkpkgs.homeManagerModules.default
  ];

  # MikanOS home options
  # home-config #

  # User packages
  home.packages = with pkgs; [
    hello
  ];

  # User packages with settings
  # https://nix-community.github.io/home-manager/options.xhtml
  programs.foot.enable = true;
  programs.firefox.enable = true;

  home.stateVersion = systemConfig.system.stateVersion;
}
