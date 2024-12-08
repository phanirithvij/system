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
in
rec {
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
  ];
  aliasModules = map (a: mkAliasModule' (builtins.elemAt a 0) (builtins.elemAt a 1)) groups;
}
