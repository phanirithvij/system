{
  lib,
  config,
  username,
  hostname,
  ...
}:
let
  spAccessor =
    name:
    if name == "" then
      "$SYSTEM_DIR#homeConfigurations.${username}@${hostname}.activationPackage"
    else
      "$SYSTEM_DIR#homeConfigurations.${username}@${hostname}.config.specialisation.${name}.configuration.home.activationPackage";
  # pl = builtins.replaceStrings [ "${placeholder "out"}" ] [ "@out@" ];
  mkHmSpecialisation =
    name:
    let
      x = lib.debug.traceSeq { val = spAccessor name; } "";
    in
    {
      specialisation.${name}.configuration = {
        imports = [ (./. + "/${name}.nix") ];
        # nh understands this location
        xdg.dataFile."home-manager/specialisation".text = name;
        home.file."${config.xdg.cacheHome}/home-manager/${name}".text = x;
        # xdg.dataFile."home-manager/outpath".text = pl "${placeholder "out"}";
        # xdg.dataFile."home-manager/outpath".text = config.home.activationPackage.outPath; # infrec
      };
    };
  # Move to archive if need to disable a specialisation
  specials = lib.pipe (builtins.readDir ./.) [
    (lib.filterAttrs (n: v: v != "directory" && n != "default.nix"))
    builtins.attrNames
    (map (lib.splitString "."))
    (map (x: builtins.elemAt x 0))
  ];
  combine = lib.foldl (a: b: lib.recursiveUpdate a b) { };
  specialisations = combine (map mkHmSpecialisation specials);
  no-specialisation = lib.mkIf (config.specialisation != { }) {
    # no-specialisation, default case
  };
in
{
  imports = [
    (_: specialisations)
    (_: no-specialisation)
  ];
  xdg.dataFile."home-manager/specialisations".text = builtins.concatStringsSep "\n" specials;
  /*
    TODO
    specialisation sync with os script
    make a specialisation fzf switcher thing?
      navi command for nh? hm-specialisation-switch
    SIDEA: can each navi command be a own command, like an alias, eg. hmss - hm-specialisation-switch
    which calls navi with appropriate args, so that `nh home switch -s <selector> $SYSTEM_DIR` can be called
  */
}
