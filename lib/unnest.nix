{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  ...
}:
let
  /*
    claude generated and hand modified
    given { a.b.c.d = drv; x.y = drv; w = drv; } -> { d = drv; y = drv; w = drv; }
  */
  unNestAttrs =
    attrs:
    let
      collectValues =
        prefix: value:
        if !builtins.isAttrs value || (value ? __toString || value ? outPath) then
          let
            name = if prefix == [ ] then "unnamed" else lib.last prefix;
          in
          [ (lib.nameValuePair name value) ]
        else
          lib.concatLists (lib.mapAttrsToList (name: val: collectValues (prefix ++ [ name ]) val) value);
      allPairs = collectValues [ ] attrs;
    in
    lib.listToAttrs allPairs;
in
unNestAttrs
