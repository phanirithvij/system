{ flake-inputs, pkgs, ... }:
{
  nix = {
    # https://discourse.nixos.org/t/24-05-add-flake-to-nix-path/46310/14
    channel.enable = false;
    registry = {
      nixpkgs.flake = flake-inputs.nixpkgs;
      n.flake = flake-inputs.nixpkgs;
    };
    package = pkgs.nixVersions.stable;
    settings =
      let
        users = [
          "root"
          "rithvij"
          "hydra" # TODO maybe hydra needs @wheel
        ];
      in
      {
        nix-path = "nixpkgs=flake:nixpkgs";
        allowed-uris = "github: gitlab: git+ssh:// https://github.com/";
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        trusted-users = [ "@wheel" ];
        allowed-users = users;
        #sandbox = "relaxed";
        http-connections = 50;
        log-lines = 50;
        # below need to be user specific? so home-manager?
        substituters = [
          "https://loudgolem-nur-pkgs-0.cachix.org"
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
          "https://niri.cachix.org"
        ];
        trusted-public-keys = [
          "loudgolem-nur-pkgs-0.cachix.org-1:OINy4hRqrmCH0sslp+tQo4hiBEZJEgA1epza03g5rvY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        ];
        # https://github.com/NixOS/nix/issues/8953#issuecomment-1919310666
        # don't need it really
        flake-registry = "";
      };
  };
  system.switch.enableNg = true;
  system.switch.enable = false;
  nixpkgs.config.allowUnfree = true;
}
