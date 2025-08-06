{
  buildWineApplication,
  fetchurl,
  wineWowPackages,
  makeDesktopItem,
  ...
}:
buildWineApplication rec {
  pname = "clip-studio-paint";
  version = "1.13.2";

  # In theory, 1.13.2 has windows 10 support,
  # but wine crashes a few seconds after csp launches
  windowsVersion = "win81";
  winePackage = wineWowPackages.unstable;

  withCjk = true;

  installer = fetchurl {
    url = "https://vd.clipstudio.net/clipcontent/paint/app/1132/CSP_1132w_setup.exe";
    hash = "sha256-cFJcShjYMxwUKo7OJVRxQE3R/nrKa8cuqZWjA9Gmq/g=";
  };

  executable = ''C:\Program Files\CELSYS\CLIP STUDIO 1.5\CLIP STUDIO PAINT\CLIPStudioPaint.exe'';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = fetchurl {
        url = "https://www.clipstudio.net/view/img/common/favicon.ico";
        hash = "sha256-VKeb/CS3Jh/NW2/oa+lfQStJkwAf6+IKOQuuMNcYSGg=";
      };
      desktopName = "Clip Studio Paint";
      startupWMClass = "clipstudiopaint.exe";
    })
  ];
}
