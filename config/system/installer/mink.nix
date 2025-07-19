let
  escapePerlSymbols = builtins.replaceStrings [ "$" ] [ "\\$" ];
in
{
  modifyOSRelease = true;
  installer = {
    enable = true;
    configuration = {
      system = escapePerlSymbols (builtins.readFile ../livecd/mink.nix);
      home = escapePerlSymbols (builtins.readFile ../../home/mikan/mink.nix);
    };
  };
}
