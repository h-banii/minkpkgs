{
  minkpkgs,
  system,
  callPackage,
}:
{
  mink-install-tools = callPackage ./mink-install-tools/mink-generate-config {
    nixosOptionsJSON = minkpkgs.legacyPackages.${system}.nixosOptionsDoc.optionsJSON;
    homeManagerOptionsJSON = minkpkgs.legacyPackages.${system}.homeManagerOptionsDoc.optionsJSON;
  };
}
