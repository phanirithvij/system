{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    git-absorb
    git-bug
    gitbatch
    gitcs
    git-who
    gitnr # tui to manage gitignore files
    wrappedPkgs.git-prole
  ];
  imports = [
    ./gh.nix
    ./lazygit.nix
  ];
  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      userName = "phanirithvij";
      userEmail = "phanirithvij2000@gmail.com";
      # broken https://github.com/NixOS/nixpkgs/pull/334814
      delta.enable = true;
      signing.format = "ssh";
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF8/+FK1TAZV7p1a92/ykOXqPGt34rsiHxXLgVG3b/3x rithvij@iron";
      signing.signByDefault = true;
      extraConfig = {
        commit.gpgsign = true;
        gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
        init = {
          defaultBranch = "main";
        };
        url = {
          "https://github.com/" = {
            insteadOf = [
              "gh:"
              "github:"
            ];
          };
        };
      };
    };
  };
}
