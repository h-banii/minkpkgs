{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  imports = [
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    foot
  ];

  programs.firefox.enable = true;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };
}
