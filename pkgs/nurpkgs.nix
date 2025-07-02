{
  flake-inputs,
  lib,
  system,
  ...
}:
let
  inherit (lib) isDerivation;
  #debug = lib.traceSeq (builtins.attrNames flake-inputs.nur-pkgs.packages.${system}) f;
  unstablePkgs' = lib.attrsets.filterAttrs (
    n: v:
    let
      # skip individual packages by name
      byName = builtins.elem n [ ];
      # skip packages marked as broken
      broken = v ? meta && v.meta.broken;
    in
    (if byName then lib.warn "Manually disabled nur package: ${n}" false else true)
    && (if broken then lib.warn "Skipping broken nur package: ${n}" false else true)
    && (isDerivation v)
  ) flake-inputs.nur-pkgs.packages.${system}.unstablePkgs;
  flakePkgs' = lib.attrsets.filterAttrs (
    n: v:
    let
      # skip individual packages by name
      byName = builtins.elem n [
        "nixpkgs-track" # used in wrappedPkgs, don't use directly
      ];
      # skip packages marked as broken
      broken = v ? meta && v.meta.broken;
    in
    (if byName then lib.warn "Manually disabled nur package: ${n}" false else true)
    && (if broken then lib.warn "Skipping broken nur package: ${n}" false else true)
    && (isDerivation v)
  ) flake-inputs.nur-pkgs.packages.${system}.flakePkgs;
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
      ];
      # skip packages marked as broken
      broken = v ? meta && v.meta.broken;
    in
    !byNameNoWarn
    && (if byName then lib.warn "Manually disabled nur package: ${n}" false else true)
    && (if broken then lib.warn "Skipping broken nur package: ${n}" false else true)
    && (isDerivation v)
  ) flake-inputs.nur-pkgs.packages.${system};

  # leaves are filtered, good and unnested packages
  leaves = builtins.attrValues (rest // flakePkgs' // unstablePkgs');
in
rest
// {
  inherit leaves;
  # has all original entires for flakePkgs and unstablePkgs including broken
  inherit (flake-inputs.nur-pkgs.packages.${system}) flakePkgs unstablePkgs;
}
