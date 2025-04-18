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
      export PATH="$PATH:$HOME/.local/bin:$HOME/go/bin"
      export OWN_DIR="/shed/Projects/\!Own"
      export SYSTEM_DIR="/shed/Projects/system"

      fzfalias() {
        fzf --height 60% --layout=reverse \
          --cycle --keep-right --padding=1,0,0,0 \
          --color=label:bold --tabstop=1 --border=sharp \
          --border-label="  $1  " \
          "''${@:2}"
      }
      lazygit_fzf() {
        local repo
        repo=$(yq ".recentrepos | @tsv" ~/.config/lazygit/state.yml | sed -e "s/\"//g" -e "s/\\\\t/\n/g" | fzfalias "lazygit-repos")
        if [ -n "$repo" ]; then
           pushd "$repo" || return 1
           lazygit
           popd || return 1
        fi
      }
    '';
  };
}
