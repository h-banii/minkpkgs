{
  modifyOSRelease = true;
  installer = {
    enable = true;
    configuration = {
      system = builtins.readFile ../livecd/mink.nix;
      home = builtins.readFile ../../home/mikan/mink.nix;
    };
  };
}
