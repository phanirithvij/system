{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lazyPkgs.tdl
    lazyPkgs.telegram-desktop
    # TODO nixos module for this?
    lazyPkgs.tg-archive # https://github.com/knadh/tg-archive/issues/158
    # TODO teldrive?
    # but teldrive can't run as hm service since it requires postgres
    # TODO rclone declarative mount service
  ];
}
