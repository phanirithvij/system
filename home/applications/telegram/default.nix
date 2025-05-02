{ pkgs, ... }:
{
  home.packages = [
    pkgs.tdl
    pkgs.telegram-desktop
    # TODO nixos module for this?
    pkgs.tg-archive # https://github.com/knadh/tg-archive/issues/158
    # TODO teldrive?
    # but teldrive can't run as hm service since it requires postgres
    # TODO rclone declarative mount service
  ];
}
