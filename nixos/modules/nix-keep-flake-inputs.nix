{ flake-inputs, ... }:
{
  # prevent all flake inputs from gc, time consuming to query from substitutors,copy,extract
  # https://github.com/NixOS/nix/issues/3995#issuecomment-2081164515
  system.extraDependencies =
    let
      collectFlakeInputs =
        input:
        [ input ] ++ builtins.concatMap collectFlakeInputs (builtins.attrValues (input.inputs or { }));
    in
    builtins.concatMap collectFlakeInputs (builtins.attrValues flake-inputs);
  # TODO alternative solutions in https://github.com/NixOS/nix/issues/7138
  # this is bandaid fix only for the system flake
  # but what about gc roots for project level flakes?
  # direnv and nix-direnv are good but `nh clean all` gets rid of everything
  # so need to use `nh clean all --nogcroots` but sometimes to reclaim diskspace I have to do a full clean
  # maybe nh clean using least recently used thing?
}
