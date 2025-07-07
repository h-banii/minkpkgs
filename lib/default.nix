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
    import =
      filePath: moduleArgs: modulePath:
      import filePath (
        moduleArgs
        // {
          modulePath = moduleArgs.modulePath ++ modulePath;
        }
      );
  };
}
