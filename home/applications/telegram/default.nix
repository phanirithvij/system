{ pkgs, ... }:
{
  home.packages = [
    pkgs.tdl
    pkgs.telegram-desktop
    # TODO teldrive?
    # but teldrive can't run as hm service since it requires postgres
    # TODO rclone declarative mount service
  ];
}
