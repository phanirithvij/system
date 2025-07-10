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
        mkdir -p "$out/${pname}"
        pushd "${pkg.pkg}/share/applications" >/dev/null 2>&1 || exit 0
        ls -l
        cp -rL *.desktop "$out/${pname}"
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
