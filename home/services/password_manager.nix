# https://github.com/dfangx/nixos-config/blob/master/homeManagerModules/services/password_manager.nix

# https://reddit.com/r/KeePass/comments/1bor6zm/comment/kwsp65m
# https://keepassxc.org/docs/KeePassXC_UserGuide#_automatic_database_opening
{ pkgs, ... }: {
  programs.keepassxc.enable = true;
  programs.keepassxc.package = pkgs.nurPkgs.keepassxc;
}
