{ flake-inputs, pkgs, ... }:
{
  nix = {
    registry = {
      nixpkgs.flake = flake-inputs.nixpkgs;
      n.flake = flake-inputs.nixpkgs;
    };
    package = pkgs.nixFlakes;
    settings =
      let
        users = [
          "root"
          "rithvij"
          "hydra" # TODO maybe hydra needs @wheel
        ];
      in
      {
        allowed-uris = "github: gitlab: git+ssh:// https://github.com/";
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        trusted-users = [ "@wheel" ];
        allowed-users = users;
        #sandbox = "relaxed";
        http-connections = 50;
        log-lines = 50;
        substituters = [
          "https://cosmic.cachix.org/"
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
  };
  system.switch.enableNg = true;
  system.switch.enable = false;
  nixpkgs.config.allowUnfree = true;
}
