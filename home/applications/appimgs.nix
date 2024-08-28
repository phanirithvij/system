_: {
  #rustdesk takes up time to compile and UI is bad. I prefer its AppImage on nixos
  home.file."Desktop/rustdesk-x86_64.AppImage" = {
    source = builtins.fetchurl {
      url = "https://github.com/rustdesk/rustdesk/releases/download/1.3.0/rustdesk-1.3.0-x86_64.AppImage";
      sha256 = "1h8b75bx1h16p5wz598nvn2yrbgs4znzr1cvfgzy26cnxv0804wk";
    };
    executable = true;
  };

  #TODO write an overlay to build from git rev instead later. For now download from their releases on home-page
  home.file."Desktop/subtitlecomposer-latest-x86_64.AppImage" = {
    source = builtins.fetchurl {
      url = "https://downloadcontent.opensuse.org/repositories/home:/maxrd2/AppImage/subtitlecomposer-latest-x86_64.AppImage";
      sha256 = "0ngwsiywgl8kcr08gfp0ismkskhqrf8gwc2y3dwqb3fm4mhsbjvm";
    };
    executable = true;
  };
}
