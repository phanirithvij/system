{
  flake-inputs,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    # https://discourse.nixos.org/t/24-05-add-flake-to-nix-path/46310/14
    # https://discourse.nixos.org/t/where-is-nix-path-supposed-to-be-set/16434/5
    channel.enable = false;
    # https://search.nixos.org/options?channel=unstable&show=nix.nixPath&query=nix.nixPath
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
    # system level registry
    # https://discord.com/channels/568306982717751326/570351749848891393/1347223140375461990
    # there is also user level registry
    # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.registry
    registry = lib.mkForce {
      nixpkgs.flake = flake-inputs.nixpkgs;
      n.flake = flake-inputs.nixpkgs;
    };
    package = pkgs.nixVersions.latest;
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
        experimental-features = "nix-command flakes ca-derivations";
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
        ];
        trusted-public-keys = [
          "loudgolem-nur-pkgs-0.cachix.org-1:OINy4hRqrmCH0sslp+tQo4hiBEZJEgA1epza03g5rvY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        # https://github.com/NixOS/nix/issues/8953#issuecomment-1919310666
        # global flake-registry, don't need it really
        flake-registry = "";
      };
  };
  system.switch.enable = true;
  system.rebuild.enableNg = true;
}
