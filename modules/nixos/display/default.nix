{ modulePath, moduleLib, ... }@moduleArgs:
{ ... }:
{
  imports = [
    (moduleLib.import ./wayland moduleArgs [ "wayland" ])
  ];
}
