{
  fetchurl,
  runCommandLocal,
  ascii-image-converter,
  ...
}:
rec {
  wallpaper = fetchurl {
    url = "https://static-cdn.jtvnw.net/jtv_user_pictures/6a6e811c-aca8-4bde-a3f7-ea3f2d5fca55-profile_banner-480.png";
    hash = "sha256-zB0N6c+wJbFZwIqUDEIBAyhDSoaefmrWDT5L2EE2BrQ=";
  };
  logo = fetchurl {
    url = "https://yt3.ggpht.com/RIWEh-tuhMXXExCZ3_BKK0u0lw9GAek4SZk_sMxQksk_utddEBuf-4BUDC8ORScsbnuk6VQ4dA=s480-c-k-c0x00ffffff-no-rj";
    hash = "sha256-DWoBl3PtxI3H8b9sKo0NP86I/TrQYRsa5sYJ+l8a0gU=";
  };
  ascii-logo =
    runCommandLocal "mikan-ascii-logo"
      {
        nativeBuildInputs = [ ascii-image-converter ];
      }
      ''
        ascii-image-converter -C -W 40 ${logo} > $out
      '';
  shader = ./shader.frag;
}
