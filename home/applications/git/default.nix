{ pkgs, ... }:
{
  home.packages = [
    pkgs.gitbatch
    pkgs.hub
    pkgs.gitcs
    pkgs.git-bug
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
      #delta.enable = true;
      extraConfig = {
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
