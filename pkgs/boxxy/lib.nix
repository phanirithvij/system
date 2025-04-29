# https://github.com/viperML/wrapper-manager/issues/18
# wrap the binary for pkg in a boxxy call
{
  pkgs,
  pkg,
  mappings ? [ ],
}:
pkgs.callPackage (
  {
    boxxy,
    copyDesktopItems,
    lib,
    makeWrapper,
    stdenv,

    binaryName ? lib.meta.getExe pkg,
  }:

  let
    binaryBaseName = builtins.baseNameOf binaryName;
    boxxyMappings =
      /*
        lib.traceSeq x x;
        x =
      */
      lib.concatStringsSep " " (
        lib.map (
          m:
          "--add-flags '-r' "
          # Pure black magic, nix should have a sane way to do this, find it TODO
          # bash
          + ''
            --add-flags "\"$(\
              eval echo $(printf "%q" '${m.target}:${m.rewrite}:${m.mode}') \
            )\""\
          ''
        ) mappings
      );
  in

  stdenv.mkDerivation {
    pname = "${pkg.pname}-boxxy";

    inherit (pkg) version meta;

    src = pkg;

    nativeBuildInputs = [
      makeWrapper
      copyDesktopItems
    ];
    desktopItems = [ pkg ];

    # wrap binary and also boxxy
    # boxxy -c flag is not there, need to use -r and --no-config.
    # exploiting XDG_CONFIG_HOME to pass arbitrary config to boxxy
    postBuild = ''
      mkdir -p $out/bin
      echo "${boxxyMappings}"
      makeShellWrapper ${lib.meta.getExe boxxy} $out/bin/${binaryBaseName} \
        ${boxxyMappings} \
        --add-flags ${binaryName}
    '';

    preFixup = ''
      shopt -s nullglob
      for desktopFile in $out/share/applications/*
      do
        substituteInPlace "$desktopFile" --replace ${binaryName} $out/bin/${binaryBaseName}
      done
      shopt -u nullglob
    '';
  }
) { }
