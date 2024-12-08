{
  pkgs,
  self,
  system,
  treefmtCfg,
}:
pkgs.mkShellNoCC {
  inherit (self.checks.${system}.git-hooks-check) shellHook;
  buildInputs = self.checks.${system}.git-hooks-check.enabledPackages;
  packages =
    with pkgs;
    [
      nh
      cachix
      xc
      dprint
    ]
    ++ [
      treefmtCfg.wrapper
      (pkgs.lib.attrValues treefmtCfg.programs)
    ];
}
