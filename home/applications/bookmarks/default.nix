{ pkgs, ... }:
{
  imports = [ ./navi.nix ];
  # TODO buku server, buku webext etc?
  # https://github.com/samhh/bukubrow-webext/issues/165
  home.packages = [ pkgs.buku ];
  services.espanso = {
    enable = true;
    x11Support = true;
    waylandSupport = true;
    # TODO config, matches
    # gh auth token | xclip -sel clipboard
    # https://github.com/phanirithvij
    # https://github.com/phanirithvij/system
    # @phanirithvij
    # private matches
    # TODO other crazy things
    # navi matches module
    # passwords matches
    # authpass module
    # lesspass module
    # gopass module
    # buku module
  };
}
