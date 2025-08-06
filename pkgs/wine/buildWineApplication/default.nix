{
  writeShellApplication,
  lib,
  wineWowPackages,
  winetricks,
  ...
}:
{
  pname,
  version,
  installer,
  executable ? "explorer",

  winePackage ? wineWowPackages.staging,
  winetricksPackage ? winetricks,

  withCjk ? false,
  extraTricks ? [ ],

  use32Bit ? false,
  windowsVersion ? "win10",
  wineprefix ? "$HOME/.nix-mink-wine/${pname}-${version}",
}:
let
  writeWineApplication =
    let
      WINEPREFIX = wineprefix;
      WINEARCH = if use32Bit then "win32" else "win64";
    in
    args:
    writeShellApplication (
      {
        derivationArgs = {
          allowSubstitutes = false;
          preferLocalBuild = true;
        };

        runtimeEnv = {
          inherit WINEARCH;
        };

        # We need to do it this way because runtimeEnv uses single quotes
        text = ''
          export WINEPREFIX="${WINEPREFIX}"
        ''
        + args.text;
      }
      // (builtins.removeAttrs args [ "text" ])
    );

  builder =
    let
      tricks = [ ] ++ lib.optional withCjk "cjkfonts" ++ extraTricks;
      tricksString = lib.lists.foldl (elm: acc: acc + toString (elm)) "" tricks;
    in
    writeWineApplication {
      name = "wine-build";

      runtimeInputs = [
        winePackage
        winetricksPackage
      ];

      text = ''
        printf "\e[1mModifying wine prefix...\e[0m\n"
        mkdir -pv "$WINEPREFIX"
        wineboot -u
        winecfg /v ${windowsVersion}
      ''
      + lib.optionalString (tricks != [ ]) ''
        winetricks --unattended ${tricksString}
      ''
      + ''
        COMMAND="''${1:-install}"

        case "$COMMAND" in
          --install)
            wine ${installer}
            ;;
          --no-install|*)
            ;;
        esac
      '';
    };
in
writeWineApplication {
  name = pname;

  runtimeInputs = [
    builder
    winePackage
  ];

  text = ''
    for var in WINEPREFIX WINEARCH; do
      printf '\e[1;35m%s: \e[0m%s\n' "$var" "''${!var:-""}"
    done

    COMMAND="''${1:-run}"

    case "$COMMAND" in
      build|rebuild|update)
        wine-build --no-install
        ;;
      install|reinstall)
        wine-build --install
        ;;
      run)
        if [ ! -d "$WINEPREFIX" ]; then
          wine-build --install
        fi
        wine '${executable}'
        ;;
    esac

    wineserver -k
  '';
}
