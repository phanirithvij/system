{ pkgs, treefmtCfg }:
pkgs.mkShell {
  packages =
    with pkgs;
    [
      nh
      xc
      statix
      deadnix
    ]
    ++ [
      treefmtCfg.wrapper
      (pkgs.lib.attrValues treefmtCfg.programs)
    ];
}
