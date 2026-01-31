{
  flake-inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  nix = {
    # https://discourse.nixos.org/t/24-05-add-flake-to-nix-path/46310/14
    # https://discourse.nixos.org/t/where-is-nix-path-supposed-to-be-set/16434/5
    channel.enable = false;
    # https://search.nixos.org/options?channel=unstable&show=nix.nixPath&query=nix.nixPath
    # This is making it copying "/nix/store/...-nixpkgs-20250625.aabcfcc-patched" to the store
    #nixPath = [ "nixpkgs=flake:nixpkgs" ];
    nixPath = [ "nixpkgs=${flake-inputs.nixpkgs'}" ];
    # system level registry
    # https://discord.com/channels/568306982717751326/570351749848891393/1347223140375461990
    # there is also user level registry
    # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.registry
    registry = lib.mkForce {
      nixpkgs.flake = flake-inputs.nixpkgs';
      n.flake = flake-inputs.nixpkgs';
    };
    # for maralorn/nix-output-monitor#201
    # and for https://discourse.nixos.org/t/-/69577
    package = pkgs.nixVersions.git; # I wanna bleed on the edge
    #package = pkgs.nixVersions.latest;
    # https://github.com/NixOS/nix/issues/6536#issuecomment-1254858889
    # can fail at runtime https://github.com/NixOS/nix/issues/6536#issuecomment-2774658643
    extraOptions = ''
      !include ${config.sops.templates.nix_access_tokens.path}
    '';
    settings =
      let
        users = [
          "root"
          "rithvij"
          "hydra" # TODO maybe hydra needs @wheel
          "nod-builder"
        ];
      in
      {
        # see https://github.com/NixOS/nixpkgs/pull/442687#discussion_r2347105354
        allow-import-from-derivation = false; # default is true
        trace-import-from-derivation = true; # trace if I do use it
        allowed-uris = "github: gitlab: git+ssh:// https://github.com/";
        experimental-features = [
          "flakes"
          "nix-command"
          "auto-allocate-uids"
          "cgroups"
          # "ca-derivations" # breaks nix develop based update scripts
        ];
        auto-allocate-uids = true;
        system-features = [
          "benchmark"
          "big-parallel"
          "kvm"
          "nixos-test"
          "uid-range"
        ];
        auto-optimise-store = true;
        trusted-users = [
          "@wheel"
          "nod-builder"
        ];
        allowed-users = users;
        #sandbox = "relaxed";
        http-connections = 50;
        log-lines = 50;
        # below need to be user specific? so home-manager?
        # NOTE: trusted-substituters will not work!
        # found it the hard way when working on Tomas's dotfiles
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

        builders-use-substitutes = true;
      };
  };

  nix.distributedBuilds = false;

  nix.buildMachines = [
    {
      hostName = "makemake.ngi.nixos.org"; # TODO how to ensure I use it only for ngipkgs work
      sshUser = "remotebuild";
      sshKey = "/home/rithvij/.ssh/id_ed25519";
      # got this via base64 -w0 makemake.pub
      # makemake.pub is `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4ejRuAQPx6AbuS1u+Q7UUi1TIwkY2S//kjgpBxYNfU remotebuild@makemake.ngi.nixos.org`
      # got that from ~/.ssh/known_hosts after trying it with `nom build -f . collabora-desktop --builders "ssh-ng://remotebuild@makemake.ngi.nixos.org" --max-jobs 0`
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUQ0ZWpSdUFRUHg2QWJ1UzF1K1E3VVVpMVRJd2tZMlMvL2tqZ3BCeFlOZlUgcmVtb3RlYnVpbGRAbWFrZW1ha2UubmdpLm5peG9zLm9yZwo="; # makemake with user@host
      inherit (pkgs.stdenv.hostPlatform) system;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
        "ca-derivations"
      ];
    }
  ];

  sops.secrets.github_pat.owner = config.users.users.rithvij.name;
  sops.templates.nix_access_tokens = {
    mode = "0400";
    content = "access-tokens = github.com=${config.sops.placeholder."github_pat"}";
  };

  system.switch.enable = true;
}
