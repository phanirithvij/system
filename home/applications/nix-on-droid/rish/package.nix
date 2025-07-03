{
  lib,
  fetchzip,
  coreutils,
  writeShellScriptBin,
  makeWrapper,
  stdenv,

  appId ? "com.termux.nix", # can be "com.termux"
  ...
}:
let
  # source `cat $(which getprop)` in termux app
  # not available in nix-on-droid
  # https://github.com/termux/termux-tools/blob/0c6eaf2e11289b5c6587615501aafec58b9b21e3/scripts/Makefile.am#L47
  getprop = writeShellScriptBin "getprop" ''
    #!/system/bin/sh
    unset LD_LIBRARY_PATH LD_PRELOAD
    PATH=/system/bin exec /system/bin/getprop "$@"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rish";
  version = "13.6.0";
  src = fetchzip {
    url = "https://github.com/RikkaApps/Shizuku/releases/download/v${finalAttrs.version}/${finalAttrs.apkName}";
    hash = "sha256-HeWcdTbLKced78dfhou5Fvve4cFMKIFermwNo04QqR4=";
    stripRoot = false;
    extension = "zip";
    postFetch = ''
      cd $out
      find ! -name "assets" ! -wholename "./assets/rish*" ! -name "." -print0 | xargs -0 rm -rf
      mv assets/rish assets/rish_shizuku.dex .
      rmdir assets
      chmod +x rish
    '';
  };

  # handled by update script
  apkName = "shizuku-v13.6.0.r1086.2650830c-release.apk"; # 2025-05-25

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -rp $src/* $out/bin
    wrapProgram $out/bin/rish \
     --set RISH_APPLICATION_ID ${appId} \
     --set PATH ${
       lib.makeBinPath [
         getprop
         coreutils
       ]
     }
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://github.com/RikkaApps/Shizuku-API/tree/master/rish";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.phanirithvij ];
    mainProgram = "rish";
    # TODO can build that from source like nix-on-droid and status-im
    sourceProvenanace = [ lib.sourceTypes.binaryBytecode ]; # for the dex file
  };
})
