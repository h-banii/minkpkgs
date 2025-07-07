{ modulePath, ... }@moduleArgs:
{ ... }:
{
  imports = [
    (import ./wayland (moduleArgs // { modulePath = modulePath ++ [ "wayland" ]; }))
  ];
}
