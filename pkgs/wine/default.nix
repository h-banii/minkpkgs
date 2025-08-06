{ callPackage, ... }:
rec {
  buildWineApplication = callPackage ./buildWineApplication { };

  clip-studio-paint = callPackage ./clip-studio-paint {
    inherit buildWineApplication;
  };
}
