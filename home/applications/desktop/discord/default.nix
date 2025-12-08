{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lazyPkgs.discord
    # TODO whatever vencord or what not
    # read somewhere all other discord clients are electron web app wrappers
    # different to the official one
    # so they have severe limitations
  ];
}
