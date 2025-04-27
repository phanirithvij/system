{ pkgs, ... }:
{
  # TODO logrotate bash_history
  # TODO borgmatic backup to gdrive
  # TODO private github repo
  home.packages = [ pkgs.logrotate ];
  # TODO blesh
  # https://github.com/tars0x9752/home/tree/main/modules/blesh
  programs.bash = {
    enable = true;
    enableCompletion = true;
    sessionVariables = {
      HISTTIMEFORMAT = "%Y-%m-%d-%H%M%S ";
    };
    historyControl = [
      "ignoredups"
      "erasedups"
      "ignorespace"
    ];
    historyFileSize = 99999999;
    historySize = 99999999;
    historyIgnore = [
      "l"
      "ls"
      "ll"
      "lf"
      "laz"
      "ta"
      "t"
    ];
    bashrcExtra = ''
      shopt -s expand_aliases
      shopt -s histappend
    '';
  };
}
