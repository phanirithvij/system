{
  flake-inputs,
  lib,
  pkgs,
  ...
}:
# https://github.com/nix-community/nix-on-droid/blob/master/modules/environment/nix.nix
{
  nix = {
    # This is making it copying "/nix/store/...-nixpkgs-20250625.aabcfcc-patched" to the store
    #nixPath = [ "nixpkgs=flake:nixpkgs" ];
    nixPath = [ "nixpkgs=${flake-inputs.nixpkgs'}" ];
    # system level registry
    registry = lib.mkForce {
      nixpkgs.flake = flake-inputs.nixpkgs';
      n.flake = flake-inputs.nixpkgs';
    };
    package = pkgs.nixVersions.latest;
    substituters = [
      "https://loudgolem-nur-pkgs-0.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trustedPublicKeys = [
      "loudgolem-nur-pkgs-0.cachix.org-1:OINy4hRqrmCH0sslp+tQo4hiBEZJEgA1epza03g5rvY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extraOptions = ''
      allowed-uris = github: gitlab: git+ssh:// https://github.com/
      experimental-features = nix-command flakes ca-derivations
      # can't use on nix-on-droid, /nix/store/.links can't be populated
      # because android fs doesn't support hardlinks
      # auto-optimise-store = true
      http-connections = 50
      log-lines = 50
      # https://github.com/NixOS/nix/issues/8953#issuecomment-1919310666
      # global flake-registry, don't need it really
      flake-registry =
    '';
  };
}
