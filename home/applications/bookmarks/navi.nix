{
  flake-inputs,
  pkgs,
  wifipassFile,
  ...
}:
{
  home.file.".local/share/navi/cheats/phanirithvij__navi" = {
    source = flake-inputs.navi_config;
    recursive = true;
  };
  home.file.".local/share/navi/cheats/home_manager_cheats/hm.cheat" = {
    source = pkgs.writeText "hm.cheat" ''
      % wifipass

      # pass
      cat ${wifipassFile} | grep <pwlist> | cut -d'=' -f2
      $ pwlist: cat ${wifipassFile} | cut -d'=' -f1
    '';
  };
  programs.tealdeer = {
    enable = true;
    settings = {
      display.use_pager = true;
      updates.auto_update = true;
    };
  };
  programs.navi = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      client = {
        tealdeer = true;
      };
    };
  };
  programs.bash.initExtra = ''
    if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
      if [[ ! -f /tmp/navi_eval.sh ]]; then
        ${pkgs.navi}/bin/navi widget bash \
          | sed 's/_navi_widget/_navi_widget_currdir/g' \
          | sed 's/--print/--print --path "docs:."/g' \
          | sed 's/C-g/C-j/g' \
          > /tmp/navi_eval.sh
        fi
      source /tmp/navi_eval.sh
    fi
  '';
  programs.zsh.initExtra = ''
    if [[ $options[zle] = on ]]; then
      ${pkgs.navi}/bin/navi widget zsh \
        | sed 's/_navi_widget/_navi_widget_currdir/g' \
        | sed 's/--print/--print --path "docs:."/g' \
        | sed 's/\^g/\^j/g'
        > /tmp/navi_eval.zsh
      source /tmp/navi_eval.zsh
    fi
  '';
  programs.fish.shellInit = ''
    ${pkgs.navi}/bin/navi widget fish \
      | sed 's/--print/--print --path "docs:."/g' \
      | sed 's/\\\\cg/\\\\cj/g' \
      | sed 's/_navi_smart_replace/_navi_smart_replace_currdir/g' \
      | source
  '';
}
