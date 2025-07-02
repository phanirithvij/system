{ pkgs, ... }:
{
  # neovim nvf from nur
  home.packages = [ pkgs.nurPkgs.flakePkgs.nvf ];
}
