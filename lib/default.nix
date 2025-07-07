{ lib, distroName }:
{
  mkIsoVm =
    {
      writeShellScriptBin,
      qemu,
      OVMF,
      iso,
      withUefi ? false,
    }:
    writeShellScriptBin "qemu-system-x86_64-${distroName}" ''
      ${qemu}/bin/qemu-system-x86_64 \
        ${if withUefi then "-bios ${OVMF.fd}/FV/OVMF.fd" else ""} \
        -cdrom $(echo ${iso}/iso/*.iso) \
        $QEMU_OPTS \
        "$@"
    '';
  evalModuleWithoutCheck =
    module:
    lib.evalModules {
      modules = [
        {
          options._module.args = lib.mkOption {
            internal = true;
          };
          config = {
            _module.check = false;
          };
        }
        module
      ];
    };
  module = {
    getConfig =
      { modulePrefix, modulePath, ... }: config: lib.getAttrFromPath (modulePrefix ++ modulePath) config;

    getSuperConfig =
      { modulePrefix, modulePath, ... }:
      config: lib.getAttrFromPath (modulePrefix ++ (lib.lists.init modulePath)) config;

    setOptions =
      { modulePrefix, modulePath, ... }: args: lib.setAttrByPath (modulePrefix ++ modulePath) args;

    # This assumes module path and file path match.
    import =
      { rootPath, modulePath, ... }@args:
      fileName:
      let
        filePath = lib.lists.foldl (a: b: "${a}/${b}") rootPath modulePath;
      in
      import "${filePath}/${fileName}" (
        args
        // {
          modulePath =
            modulePath
            ++ lib.strings.splitString "/" (builtins.replaceStrings [ ".nix" ] [ "" ] fileName);
        }
      );
  };
}
