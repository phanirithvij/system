_: {
  #rustdesk takes up time to compile and UI is bad. I prefer its AppImage on nixos
  home.file."Desktop/rustdesk-x86_64.AppImage" = {
    source = builtins.fetchurl {
      url = "https://github.com/rustdesk/rustdesk/releases/download/1.2.6/rustdesk-1.2.6-x86_64.AppImage";
      sha256 = "0k5sj646qhpaf711z3pw542psf6yjyfvd05gp0f4xv3wcxq6cy41";
    };
    executable = true;
  };

  #TODO write an overlay to build from git rev instead later. For now download from their releases on home-page
  home.file."Desktop/subtitlecomposer-latest-x86_64.AppImage" = {
    source = builtins.fetchurl {
      url = "https://downloadcontent.opensuse.org/repositories/home:/maxrd2/AppImage/subtitlecomposer-latest-x86_64.AppImage";
      sha256 = "1yhw01mnxpmsk0mrycr19f9mhznjpaf3yvnfw9530ysdh6d52fa9";
    };
    executable = true;
  };
}
