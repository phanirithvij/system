{
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../applications/tmux.nix
    ../../applications/docker
    ../../applications/bashmount.nix
  ];

  home.username = username;

  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";

  home.packages =
    with pkgs;
    [
      curl
      wget
      gh
      gdu
      duf
      neovim
      viddy
      lazygit
      fzf
      wrappedPkgs.lf
      ripgrep
      nix-output-monitor
      nixfmt-rfc-style
      npins
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      sysz
    ];

  xdg.mime.enable = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (lib.mkForce false); # for macos
  # aliasModule needs to be disabled too?

  home.stateVersion = "25.05";
}
