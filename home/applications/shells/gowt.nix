{ pkgs, ... }:
{
  # TODO check later the validity of the code
  programs.fish.interactiveShellInit = ''
    source ${pkgs.gwt}/share/gwt/gwt.fish
    alias g gwt
  '';

  programs.bash.initExtra = ''
    source ${pkgs.gwt}/share/gwt/gwt.sh
  '';

  programs.zsh.initContent = ''
    source ${pkgs.gwt}/share/gwt/gwt.sh
    alias g=gwt
  '';
}
