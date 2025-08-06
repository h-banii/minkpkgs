{
  writeShellApplication,
  lib,
  wine,
  winetricks,
  ...
}:
{
  pname,
  installer,

  winePackage ? wine,
  winetricksPackage ? winetricks,

  withCjk ? false,
  extraTricks ? [ ],

  use32Bit ? false,
  windowsVersion ? null,
  wineprefix ? "$HOME/.nix-mink-wine/${pname}",
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
        printf "\e[1mCreating wine prefix at %s...\e[0m\n" "$WINEPREFIX"
        wineboot -u
      ''
      + lib.optionalString (windowsVersion != null) ''
        winecfg /v ${windowsVersion}
      ''
      + lib.optionalString (tricks != [ ]) ''
        winetricks --unattended ${tricksString}
      ''
      + ''
        wine ${installer}
      '';
    };

  runner = writeWineApplication {
    name = "wine-run";

    runtimeInputs = [ wine ];

    text = ''
      printf "\e[1mCreating wine prefix...\e[0m\n"
    '';
  };
in
writeWineApplication {
  name = pname;

  runtimeInputs = [
    builder
    runner
  ];

  text = ''
    for var in WINEPREFIX WINEARCH; do
      printf '\e[1;35m%s: \e[0m%s\n' "$var" "''${!var:-""}"
    done

    if [ ! -d "$WINEPREFIX" ]; then
      wine-build
    fi

    wine-run
  '';
}
