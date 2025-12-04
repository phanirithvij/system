# https://fosstodon.org/@nobodyinperson/115656550607873482
# nix repl -f hunt-removed.nix --allow-import-from-derivation then `:p culprit`
let
  flake = builtins.getFlake "git+file://${toString ./.}";
  inherit (flake) nixosConfigurations;
in
{
  culprit = builtins.filter (
    l: builtins.any (v: !v) (builtins.map (p: (builtins.tryEval (p.outPath or "")).success) l.value)
  ) nixosConfigurations.homelab.options.environment.systemPackages.definitionsWithLocations;
}
