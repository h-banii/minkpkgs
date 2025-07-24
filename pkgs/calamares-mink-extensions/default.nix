{ runCommandLocal, remarshal, ... }:
runCommandLocal ""
  {
    nativeBuildInputs = [ remarshal ];
    settings = builtins.toJSON (import ./config/settings.nix);
    passAsFile = [ "settings" ];
  }
  ''
    DATA_DIR=$out/share/calamares
    LIB_DIR=$out/lib/calamares

    mkdir -p $DATA_DIR $LIB_DIR

    json2yaml $settingsPath "$DATA_DIR"/settings.conf
  ''
