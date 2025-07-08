# Provides a way to group a command and custom aliases together
# allows to turn off custom defined aliases per package
# but original aliases by home-manager programs.<name>.enableAliases etc. are unaffected
{
  pkgs,
}:
let
  hm-lib = import ../../lib/hm;
  inherit (hm-lib) mkAliasModule;
  mkAliasModule' =
    pkg: aliases:
    mkAliasModule {
      inherit (pkgs) lib;
      inherit pkg aliases;
    };
  # pkg, aliases
  # pkg -> programs."${lib.getName pkg}-aliases"
  groups = [
    [
      pkgs.duf
      {
        dufw = "CLICOLOR_FORCE=1 COLORTERM='truecolor' viddy --disable_auto_save -p -d -n 0.5 duf";
        wduf = "CLICOLOR_FORCE=1 COLORTERM='truecolor' viddy --disable_auto_save -p -d -n 0.5 duf";
        dufi = ''
          viddy --disable_auto_save -p -d -n 0.5 '
            CLICOLOR_FORCE=1 COLORTERM="truecolor" duf \
              -only local,fuse -hide-mp /boot/efi \
              -output "mountpoint, avail, usage, inodes_avail, inodes_usage, filesystem" -sort usage;
            echo /;
            btrfs fi df /;
          '
        '';
      }
    ]
    [
      pkgs.eza
      {
        l = "ls";
        l1 = "llb";
        l2 = "llab";
        llb = "eza --long --header --icons --git -B";
        llab = "eza --long --header --icons --git --all -B";
        llh = "eza --long --header --icons --git";
        llS = "eza --long --header --icons --git -B -s size";
        llSh = "eza --long --header --icons --git -s size";
        wls = "viddy --disable_auto_save -p -d -n 0.1 eza --long --header --icons -B --color=always";
        wlsa = "viddy --disable_auto_save -p -t -d -n 0.1 eza --long --header --icons -B --all --color=always";
        wll = "viddy --disable_auto_save -p -d -n 0.1 eza --long --header --icons --git -B --color=always";
        wlla = "viddy --disable_auto_save -p -t -d -n 0.1 eza --long --header --icons --git -B --all --color=always";
      }
    ]
    [
      pkgs.wrappedPkgs.tmux
      {
        t = "tmux";
        ta = "tmux a";
        at = "tmux a";
        tma = "tmux a";
      }
    ]
    [
      pkgs.jujutsu
      {
        laj = "lazyjj";
        ju = "jjui";
        fjf = "jj-fzf";
      }
    ]
  ];
  global = mkAliasModule {
    name = "global";
    inherit (pkgs) lib;
    aliases = {
      cat = "bat";
      opop = "xdg-open";
      lac = "lazyconf"; # TODO missing here, in yadm config I guess
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
      m = "micro";

      port = "netstat -tuplen";
      ports = "sudo netstat -tuplen";
      sport = "sudo lsof -i -P -n | rg LISTEN";
      wport = "viddy --disable_auto_save -p -d -n 0.2 netstat -tuplen";
      wports = "sudo viddy --disable_auto_save -p -d -n 0.2 netstat -tuplen";

      dfah = ''viddy --disable_auto_save -p -n 0.1 "df --output=source,iavail,ipcent,avail,pcent,target -h | (sed -u 1q; sort -h -r -k 4) # Sort by Avail"'';
      dffh = ''viddy --disable_auto_save -p -n 0.1 "df --output=source,iavail,ipcent,avail,pcent,target -h | (sed -u 1q; sort -h -r -k 5) # Sort by Use%"'';
      dfao = ''viddy --disable_auto_save -p -n 0.1 "df --output=source,iavail,ipcent,avail,pcent,target | (sed -u 1q; sort -h -r -k 4) # Sort by Avail"'';
      dffo = ''viddy --disable_auto_save -p -n 0.1 "df --output=source,iavail,ipcent,avail,pcent,target | (sed -u 1q; sort -h -r -k 5) # Sort by Use%"'';

      brimin = "echo 40 | sudo tee /sys/class/backlight/intel_backlight/brightness";
      brimed = "echo 750 | sudo tee /sys/class/backlight/intel_backlight/brightness";
      brimax = "cat /sys/class/backlight/intel_backlight/max_brightness | sudo tee /sys/class/backlight/intel_backlight/brightness";

      # applications
      chrome = "google-chrome-stable & disown;tmux splitw;exit";
      nixfire = "nixGL firefox & disown;tmux splitw;exit";
      f = "firefox & disown;tmux splitw;exit";
      firefox = "firefox & disown;tmux splitw;exit";
      tor = "tor-browser & disown;tmux splitw;exit";
      zoom = "zoom & disown;tmux splitw;exit";
      telegram = "telegram-desktop & disown;tmux splitw;exit";
      discord = "discord & disown;tmux splitw;exit";
      authpass = "authpass & disown;tmux splitw;exit";

      tmpsize = "sudo mount -o remount,size=8589934592 /tmp";
      dosunix = "fd -H -E=node_modules -E=.git | xargs dos2unix";
      composes = ''rg --files . | rg docker-compose.yml | fzf --preview "bat -p --color always --theme gruvbox-dark {}"'';

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

      gupupd = ''GOFLAGS="-buildmode=pie -trimpath -modcacherw -ldflags=-s" gup update'';
      # gupupd = ''GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw -ldflags=-s" gup update'';
    };
  };
  aliasModules = [
    global
  ] ++ (map (a: mkAliasModule' (builtins.elemAt a 0) (builtins.elemAt a 1)) groups);
in
{
  inherit groups aliasModules;
}
