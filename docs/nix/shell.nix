{
  mkShell,
  nodejs,
  ...
}:
mkShell {
  name = "mikan-dev";
  packages = [
    nodejs
  ];
}
