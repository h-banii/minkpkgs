{
  pkgs,
  lib,
  greeter-unwrapped,
  settings,
  ...
}:
let
  config = pkgs.writeText "h-banii.greeter-config" (builtins.toJSON settings);
  greeter = lib.getExe greeter-unwrapped;
in
pkgs.writeShellScriptBin "greeterWrapped" ''
  export H_BANII_GREET_CONFIG=${config} # TODO: Use wrapProgram
  exec ${greeter}
''
