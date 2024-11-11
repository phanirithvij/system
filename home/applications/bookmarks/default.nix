{
  config,
  pkgs,
  ...
}@args:
let
  wifipassFile = config.sops.secrets.wifi_password_file.path;
in
{
  imports = [
    (import ./navi.nix (args // { inherit wifipassFile; }))
    (import ./espanso.nix (args // { inherit wifipassFile; }))
  ];
  # TODO buku server, buku webext etc?
  # https://github.com/samhh/bukubrow-webext/issues/165
  home.packages = [ pkgs.buku ];
  sops.secrets.wifi_password_file = { };
}
