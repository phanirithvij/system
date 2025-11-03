{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    git-absorb
    #git-bug # should be in nur
    gitbatch
    gitcs
    git-who
    lazyPkgs.gitnr # tui to manage gitignore files
    wrappedPkgs.git-prole
  ];
  imports = [
    ./gh.nix
    ./lazygit.nix
  ];
  programs = {
    delta.enable = true;
    delta.enableGitIntegration = true;
    git = {
      enable = true;
      package = pkgs.gitFull;
      signing.format = "ssh";
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF8/+FK1TAZV7p1a92/ykOXqPGt34rsiHxXLgVG3b/3x rithvij@iron";
      signing.signByDefault = true;
      settings = {
        user.name = "phanirithvij";
        user.email = "phanirithvij2000@gmail.com";
        commit.gpgsign = true;
        gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
        init.defaultBranch = "main";
        url."https://github.com/".insteadOf = [
          "gh:"
          "github:"
        ];
      };
    };
  };
}
