{ pkgs, ... }:
{
  imports = [ ./navi.nix ];
  # TODO buku server, buku webext etc?
  # https://github.com/samhh/bukubrow-webext/issues/165
  home.packages = [ pkgs.buku ];
  services.espanso = {
    enable = true;
    # TODO config, matches
  };
}