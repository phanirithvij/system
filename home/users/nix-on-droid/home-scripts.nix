{ pkgs, lib, ... }:
let
  rish = pkgs.callPackage ../../applications/nix-on-droid/rish { };
in
{
  home.packages = [
    rish.rish
    (pkgs.writeShellScriptBin "navbar-hide-miui" ''
      ${lib.getExe rish.rish} -c "settings put global force_fsg_nav_bar 1"
    '')
  ];
}
