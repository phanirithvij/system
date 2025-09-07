{
  aliases ? [ ],
  lib,
  name ? lib.getName pkg,
  pkg ? null,
}:
{
  config,
  lib,
  ...
}:

let
  cfg = config.programs."${name}-aliases";
  inherit aliases;
  inherit (lib)
    mkIf
    mkMerge
    mkEnableOption
    ;
in
{
  # avoid enableAliases, e.g. eza errors with deprecated
  options.programs."${name}-aliases" = {
    enable = mkEnableOption "${name} aliases grouped";
  };

  config = mkIf cfg.enable {
    programs.bash.shellAliases = aliases;
    programs.fish = mkMerge [
      (mkIf (!config.programs.fish.preferAbbrs) {
        shellAliases = aliases;
      })
      (mkIf config.programs.fish.preferAbbrs {
        shellAbbrs = aliases;
      })
    ];
    programs.zsh.shellAliases = aliases;
    # TODO nushell ion etc
  };
}
