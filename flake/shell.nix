{
  pkgs,
  self,
  system,
  treefmtCfg,
}:
pkgs.mkShellNoCC {
  inherit (self.checks.${system}.git-hooks-check) shellHook;
  buildInputs = self.checks.${system}.git-hooks-check.enabledPackages ++ [ pkgs.bashInteractive ];
  packages =
    with pkgs;
    [
      nh
      xc
      cachix
    ]
    ++ [
      treefmtCfg.wrapper
      (pkgs.lib.attrValues treefmtCfg.programs)
    ];
}
