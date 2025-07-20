{ minkpkgs, systemConfig, ... }:
{
  imports = [
    minkpkgs.homeManagerModules.default
  ];

  # Linux Mink home options
  linuxMink = {
    # TODO: auto generate?
  };

  programs.foot.enable = true;
  programs.firefox.enable = true;

  home.stateVersion = systemConfig.system.stateVersion;
}
