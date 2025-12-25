{
  flake-inputs,
  lib,
  system,
  pkgs,
  ...
}:
let
  nurPkgsOriginal = flake-inputs.nur-pkgs.lib.getNurPkgs {
    inherit pkgs system;
  };
  inherit (lib) isDerivation;
  #debug = lib.traceSeq (builtins.attrNames nurPkgsOriginal) f;
  unstablePkgs' = lib.attrsets.filterAttrs (
    n: v:
    let
      # skip individual packages by name
      byName = builtins.elem n [
        "subtitlecomposer" # used in lazyPkgs, don't use directly
      ];
      # skip packages marked as broken
      broken = v ? meta && v.meta.broken;
    in
    (if byName then lib.warn "Manually disabled nur package: ${n}" false else true)
    && (if broken then lib.warn "Skipping broken nur package: ${n}" false else true)
    && (isDerivation v)
  ) nurPkgsOriginal.packages.unstablePkgs;
  flakePkgs' = lib.attrsets.filterAttrs (
    n: v:
    let
      # skip individual packages by name
      byName = builtins.elem n [
        "nixpkgs-track" # used in wrappedPkgs, don't use directly
        "nix-tree" # used in lazyPkgs, don't use directly
        "ghostty" # used in lazyPkgs, don't use directly
        "oranc" # must not be in hm packages, added in env.syspkgs
      ];
      # skip packages marked as broken
      broken = v ? meta && v.meta.broken;
    in
    (if byName then lib.warn "Manually disabled nur package: ${n}" false else true)
    && (if broken then lib.warn "Skipping broken nur package: ${n}" false else true)
    && (isDerivation v)
  ) nurPkgsOriginal.packages.flakePkgs;
  rest = lib.attrsets.filterAttrs (
    n: v:
    let
      # skip individual packages by name
      byName = builtins.elem n [
        "overlayShell" # not useful here
      ];
      byNameNoWarn = builtins.elem n [
        "unstablePkgs"
        "flakePkgs"
        "gitbatch" # used in lazyPkgs, don't use directly
      ];
      # skip packages marked as broken
      broken = v ? meta && v.meta.broken;
    in
    !byNameNoWarn
    && (if byName then lib.warn "Manually disabled nur package: ${n}" false else true)
    && (if broken then lib.warn "Skipping broken nur package: ${n}" false else true)
    && (isDerivation v)
  ) nurPkgsOriginal.packages;

  # leaves are filtered, good and unnested packages (For this host)
  leaves = builtins.attrValues (rest // flakePkgs' // unstablePkgs');
  # all include all packages.
  all = nurPkgsOriginal.packages;
in
rest
// {
  inherit leaves all;
  # has all original entires for flakePkgs and unstablePkgs including broken
  inherit (nurPkgsOriginal.packages) flakePkgs unstablePkgs;
}
