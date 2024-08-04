{
  config,
  lib,
  pkgs,
  writeShellApplication,
  runCommand,
  ...
}:
let
  pname = "pr-tracker-user-script";
  scriptPrTracker = pkgs.writeShellApplication {
    name = pname;
    runtimeInputs = [ pkgs.pr-tracker ];
    text = builtins.readFile ../scripts/nixinternal/pr-tracker.sh;
  };
in
runCommand pname { meta.mainProgram = pname; } ''
  mkdir -p $out/bin
  cp ${lib.getExe scriptPrTracker} $out/bin/${pname};
  substituteInPlace $out/bin/${pname} \
    --subst-var-by gh_t_pr_tracker_path ${config.sops.secrets.gh_t_pr_tracker.path}
''
