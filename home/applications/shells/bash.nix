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
      l = "ls";
      l1 = "llb";
      l2 = "llab";
      llb = "eza --long --header --icons --git -B";
      llab = "eza --long --header --icons --git --all -B";
      llh = "eza --long --header --icons --git";
      llS = "eza --long --header --icons --git -B -s size";
      llSh = "eza --long --header --icons --git -s size";
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
      copy = "xclip -sel clip";
      xcopy = "xclip -sel clip";

      t = "tmux";
      ta = "tmux a";
      at = "tmux a";
      tma = "tmux a";
      #tag = "tmsu";

      tmpsize = "sudo mount -o remount,size=8589934592 /tmp";
      dosunix = "fd -H -E=node_modules -E=.git | xargs dos2unix";
      composes = ''rg --files . | rg docker-compose.yml | fzf --preview "bat -p --color always --theme gruvbox-dark {}"'';

      port = "netstat -tuplen";
      ports = "sudo netstat -tuplen";
      sport = "sudo lsof -i -P -n | rg LISTEN";
      wport = "viddy -p -d -n 0.2 -c netstat -tuplen";
      wports = "sudo viddy -p -d -n 0.2 -c netstat -tuplen";
      dufw = "CLICOLOR_FORCE=1 COLORTERM='truecolor' viddy -p -d -n 0.5 -c duf";
      wduf = "CLICOLOR_FORCE=1 COLORTERM='truecolor' viddy -p -d -n 0.5 -c duf";
      dufi = ''CLICOLOR_FORCE=1 COLORTERM="truecolor" viddy -p -d -n 0.5 -c "duf -only local,fuse -hide-mp /boot/efi -output \"mountpoint, avail, usage, inodes_avail, inodes_usage, filesystem\" -sort usage"'';
      dfah = ''viddy -p -n 0.1 -c "df --output=source,iavail,ipcent,avail,pcent,target -h | (sed -u 1q; sort -h -r -k 4) # Sort by Avail"'';
      dffh = ''viddy -p -n 0.1 -c "df --output=source,iavail,ipcent,avail,pcent,target -h | (sed -u 1q; sort -h -r -k 5) # Sort by Use%"'';
      dfao = ''viddy -p -n 0.1 -c "df --output=source,iavail,ipcent,avail,pcent,target | (sed -u 1q; sort -h -r -k 4) # Sort by Avail"'';
      dffo = ''viddy -p -n 0.1 -c "df --output=source,iavail,ipcent,avail,pcent,target | (sed -u 1q; sort -h -r -k 5) # Sort by Use%"'';

      prog = "viddy -p -n 0.5 -c progress -w";
      wls = "viddy -p -d -n 0.1 -c exa --long --header --icons -B --color=always";
      wlsa = "viddy -p -t -d -n 0.1 -c exa --long --header --icons -B --all --color=always";
      wll = "viddy -p -d -n 0.1 -c exa --long --header --icons --git -B --color=always";
      wlla = "viddy -p -t -d -n 0.1 -c exa --long --header --icons --git -B --all --color=always";
      wpactl = ''viddy "pactl list | rg -U \".*bluez_card(.*\n)*\""'';
      mem = "viddy -p -n 0.1 -c free -h";

      chrome = "google-chrome-stable & disown;tmux splitw;exit";
      nixfire = "nixGL firefox & disown;tmux splitw;exit";
      f = "firefox & disown;tmux splitw;exit";
      firefox = "firefox & disown;tmux splitw;exit";
      tor = "~/Desktop/tor.desktop & disown;tmux splitw;exit";
      zoom = "zoom & disown;tmux splitw;exit";
      telegram = "telegram-desktop & disown;tmux splitw;exit";
      discord = "discord & disown;tmux splitw;exit";
      authpass = "authpass & disown;tmux splitw;exit";
      gupupd = ''GOFLAGS="-buildmode=pie -trimpath -modcacherw -ldflags=-s" gup update'';
      # gupupd = ''GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw -ldflags=-s" gup update'';
    };
  };
}
