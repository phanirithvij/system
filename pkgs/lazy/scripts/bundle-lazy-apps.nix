{
  gitRoot,
  ...
}:
with import <nixpkgs> { };
let
  flk = builtins.getFlake (toString gitRoot);
  lazyApps = flk.lazyApps.${builtins.currentSystem};
  getApplications =
    pname: pkg:
    stdenv.mkDerivation {
      name = "lazy-app-applications-${pname}";
      phases = [ "installPhase" ];
      installPhase = ''
        shopt -s globstar

        mkdir -p "$out/${pname}"
        pushd "${pkg.pkg}/share/applications" >/dev/null || exit 0
        cp -rL *.desktop "$out/${pname}"
        pushd "$out/${pname}" >/dev/null 2>&1 || exit 0
        source ${./sanitize_drv_name.sh}
        for i in **/*.desktop; do
          new=$(sanitize_derivation_name "$i")
          if [[ "$i" != "$new" ]]; then
            mv "$i" "$new"
          fi
        done
        popd >/dev/null 2>&1 || exit 0
      '';
    };
  paths = lib.attrValues (lib.mapAttrs getApplications lazyApps);
in
stdenv.mkDerivation {
  name = "bundle-lazy-apps";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out
    ${lib.concatMapStringsSep "\n" (path: ''
      cp -rL --no-preserve=all "${path}"/* "$out/"
    '') paths}

    # Flatten single matching .desktop files
    for dir in "$out"/*; do
      if [ -d "$dir" ]; then
        dirname=$(basename "$dir")
        desktop_file="$dir/$dirname.desktop"
        file_count=$(find "$dir" -maxdepth 1 -type f | wc -l)

        if [ "$file_count" -eq 1 ] && [ -f "$desktop_file" ]; then
          mv "$desktop_file" "$out/$dirname.desktop"
        fi
      fi
    done
    find "$out" -type d -empty -delete
  '';
}
