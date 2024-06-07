{ navi_config, pkgs, ... }:
let
  navi = pkgs.navi;
in
{
  home.packages = [ pkgs.buku ];
  programs.navi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
  programs.bash.initExtra = ''
    if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
      ${navi}/bin/navi widget bash \
        | sed 's/_navi_widget/_navi_widget_currdir/g' \
        | sed 's/--print/--print --path "$PWD"/g' \
        | sed 's/C-g/C-j/g' \
        | > /tmp/navi_eval.sh
      source /tmp/navi_eval.sh
    fi
  '';
  programs.zsh.initExtra = ''
    if [[ $options[zle] = on ]]; then
      ${navi}/bin/navi widget zsh \
        | sed 's/_navi_widget/_navi_widget_currdir/g' \
        | sed 's/--print/--print --path "$PWD"/g' \
        | sed 's/\^g/\^j/g'
        | > /tmp/navi_eval.zsh
      source /tmp/navi_eval.zsh
    fi
  '';
  programs.fish.shellInit = ''
    ${navi}/bin/navi widget fish \
      | sed 's/--print/--print --path "$PWD"/g' \
      | sed 's/\\\\cg/\\\\cj/g' \
      | sed 's/_navi_smart_replace/_navi_smart_replace_currdir/g' \
      | source
  '';
  home.file.".local/share/navi/cheats/phanirithvij__navi" = {
    source = navi_config;
    recursive = true;
  };
  programs.tealdeer.enable = true;
  services.espanso = {
    enable = true;
    # TODO config, matches
  };
}
