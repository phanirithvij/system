{ pkgs, treefmtCfg }:
pkgs.mkShell {
  packages =
    with pkgs;
    [
      nh
      xc
      dprint
    ]
    ++ [
      treefmtCfg.wrapper
      (pkgs.lib.attrValues treefmtCfg.programs)
    ];
}
