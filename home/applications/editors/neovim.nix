{ pkgs, ... }:
{
  programs.neovim = {
    package = pkgs.nurPkgs.flakePkgs.nvf;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };
}
