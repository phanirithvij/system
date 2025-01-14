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

    shellAliases = {
      cat = "bat";
      opop = "xdg-open";
      lac = "lazyconf";
      laz = "lazygit";
      lad = "lazydocker";
      lar = "lazygit_fzf";
      cd = "z";
      gb = "gitbatch";
      b = "btop";
      bl = "bluetuith";
      c = "clear";
      e = "exit";
      v = "vim";
      vim = "nvim";
      n = "v";

      #tag = "tmsu";

      tmpsize = "sudo mount -o remount,size=8589934592 /tmp";
      dosunix = "fd -H -E=node_modules -E=.git | xargs dos2unix";
      composes = ''rg --files . | rg docker-compose.yml | fzf --preview "bat -p --color always --theme gruvbox-dark {}"'';

      port = "netstat -tuplen";
      ports = "sudo netstat -tuplen";
      sport = "sudo lsof -i -P -n | rg LISTEN";
      wport = "viddy --disable_auto_save -p -d -n 0.2 netstat -tuplen";
      wports = "sudo viddy --disable_auto_save -p -d -n 0.2 netstat -tuplen";
      dfah = ''viddy --disable_auto_save -p -n 0.1 "df --output=source,iavail,ipcent,avail,pcent,target -h | (sed -u 1q; sort -h -r -k 4) # Sort by Avail"'';
      dffh = ''viddy --disable_auto_save -p -n 0.1 "df --output=source,iavail,ipcent,avail,pcent,target -h | (sed -u 1q; sort -h -r -k 5) # Sort by Use%"'';
      dfao = ''viddy --disable_auto_save -p -n 0.1 "df --output=source,iavail,ipcent,avail,pcent,target | (sed -u 1q; sort -h -r -k 4) # Sort by Avail"'';
      dffo = ''viddy --disable_auto_save -p -n 0.1 "df --output=source,iavail,ipcent,avail,pcent,target | (sed -u 1q; sort -h -r -k 5) # Sort by Use%"'';

      prog = "viddy --disable_auto_save -p -n 0.5 progress -w";
      wpactl = ''viddy --disable_auto_save "pactl list | rg -U \".*bluez_card(.*\n)*\""'';
      mem = ''
        viddy -n 0.5 -d --disable_auto_save '
          sh -c "
            echo $ free -h; free -h; echo;
            echo $ zramctl; echo; zramctl; echo;
            echo $ swapon --show; echo; swapon --show
          "
        '
      '';

      chrome = "google-chrome-stable & disown;tmux splitw;exit";
      nixfire = "nixGL firefox & disown;tmux splitw;exit";
      f = "firefox & disown;tmux splitw;exit";
      firefox = "firefox & disown;tmux splitw;exit";
      tor = "tor-browser & disown;tmux splitw;exit";
      zoom = "zoom & disown;tmux splitw;exit";
      telegram = "telegram-desktop & disown;tmux splitw;exit";
      discord = "discord & disown;tmux splitw;exit";
      authpass = "authpass & disown;tmux splitw;exit";
      gupupd = ''GOFLAGS="-buildmode=pie -trimpath -modcacherw -ldflags=-s" gup update'';
      # gupupd = ''GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw -ldflags=-s" gup update'';
    };
  };
}
