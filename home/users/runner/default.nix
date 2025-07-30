{
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../applications/docker # TODO only if linux
    ../../applications/bashmount.nix # TODO only if linux
    ../../applications/tmux.nix
  ];

  home.username = username;

  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";

  home.packages = with pkgs; [
    curl
    wget
    sysz # TODO only if linux
    # TODO system-manager conf has these for linux runner
    gh
    gdu
    duf
    neovim
    viddy
    lazygit
    fzf
    lf
    ripgrep
    nix-output-monitor
  ];

  xdg.mime.enable = lib.mkForce false; # for macos WHY
  # aliasModule needs to be disabled too?

  home.stateVersion = "24.11";
}
