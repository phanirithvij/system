{ lib, ... }:
{
  # nano like text editor, best tool for non-coding, not an ide
  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "twilight";
      relativeruler = true;
      saveundo = true;
      tabsize = 2;
      tabstospaces = true;
      wordwrap = true;
    };
  };
  home.sessionVariables = {
    EDITOR = lib.mkDefault "micro";
  };
}
