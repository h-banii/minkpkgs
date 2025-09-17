{
  minkpkgs,
  system,
  callPackage,
}:
{
  mink-install-tools = callPackage ./mink-generate-config {
    nixosOptionsJSON = minkpkgs.legacyPackages.${system}.nixosOptionsDoc.optionsJSON;
    homeManagerOptionsJSON = minkpkgs.legacyPackages.${system}.homeManagerOptionsDoc.optionsJSON;
  };
}
