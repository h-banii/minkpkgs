{
  lib,

  nixosOptionsJSON,
  homeManagerOptionsJSON,
  runCommandLocal,
  jq,

  linkFarm,
  substitute,

  writeShellApplication,
  nixos-install-tools,
  nixfmt-rfc-style,
}:
let
  mkDefaultOptions =
    optionsJSON:
    runCommandLocal "mink-system-default-options"
      {
        nativeBuildInputs = [ jq ];
      }
      ''
        jq -r 'to_entries[] | select(.value.example != null) | "\(.key) = \(.value.example.text);"' \
          < ${optionsJSON}/share/doc/nixos/options.json >$out
      '';

  replaceNixVars =
    { replacements, src }@attrs:
    substitute {
      inherit src;
      substitutions = lib.lists.flatten (
        lib.attrsets.mapAttrsToList (name: value: [
          "--replace"
          "# ${name} #"
          value
        ]) replacements
      );
      buildInputs = [
        nixfmt-rfc-style
      ];
      postInstall = ''
        nixfmt "$out"
      '';
    }
    // builtins.removeAttrs attrs [
      "replacements"
      "src"
    ];

  configPath = linkFarm "mink-generate-config-default" [
    {
      name = "home/mikan/default.nix";
      path = replaceNixVars {
        src = ./configuration/home/mikan/default.nix;
        replacements = {
          home-config = builtins.readFile (mkDefaultOptions homeManagerOptionsJSON);
        };
      };
    }
    {
      name = "system/desktop/default.nix";
      path = replaceNixVars {
        src = ./configuration/system/desktop/default.nix;
        replacements = {
          system-config = builtins.readFile (mkDefaultOptions nixosOptionsJSON);
        };
      };
    }
    {
      name = "flake.nix";
      path = ./configuration/flake.nix;
    }
  ];
in
writeShellApplication rec {
  name = "mink-generate-config";
  runtimeInputs = [
    nixos-install-tools
    nixfmt-rfc-style
  ];
  text = ''
    if [ -z "''${1:-}" ]; then
      set -- "--help"
    fi

    while [[ $# -gt 0 ]]; do
      case "$1" in
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
          printf "Unrecognized argument: %s\n\n" "$*"
          set -- "--help"
      esac
    done

    printf "Generating NixOS configuration...\n"
    nixos-generate-config --dir "$OUTPUT_DIRECTORY/system/desktop" --root "$OUTPUT_DIRECTORY"
    printf "Generating Linux Mink configuration...\n"
    cp -r --no-preserve=mode,ownership,links -L "${configPath}"/* "$OUTPUT_DIRECTORY"
  '';
}
