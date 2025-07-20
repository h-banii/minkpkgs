{
  writeShellApplication,
  nixos-install-tools,
  configPath ? ./configuration,
}:
writeShellApplication rec {
  name = "mink-generate-config";
  runtimeInputs = [
    nixos-install-tools
  ];
  text = ''
    while [[ $# -gt 0 ]]; do
      case $1 in
        --help)
          printf "${name}\n"
          printf "Flags:\n--help\n--version\n"
          printf "  --dir [path]\n    config will be saved at [path]\n"
          printf "  --root [path]\n    config will be saved at [path]/etc/nixos\n"
          exit 0
          ;;
        --dir)
          OUTPUT_DIRECTORY="$2"
          shift 2
          ;;
        --root)
          OUTPUT_DIRECTORY="$2/etc/nixos"
          shift 2
          ;;
        *)
          printf "Unrecognized argument... %s\n" "$1"
          shift
      esac
    done

    printf "Generating NixOS configuration...\n"
    nixos-generate-config --dir "$OUTPUT_DIRECTORY/system/desktop" --root "$OUTPUT_DIRECTORY"
    printf "Generating Linux Mink configuration...\n"
    cp -r --no-preserve=mode,ownership "${configPath}"/* "$OUTPUT_DIRECTORY"
  '';
}
