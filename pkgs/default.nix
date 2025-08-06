{ callPackage, ... }:
{
  buildWineApplication = callPackage ./wine/buildWineApplication { };
}
