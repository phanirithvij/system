{
  pkgs ? import <nixpkgs> {
    overlays = [
      (_: prev: {
        nvidia-offload = prev.callPackage ../pkgs/nvidia-offload.nix { };
      })
    ];
  },
  lib ? pkgs.lib,
  ...
}:
# https://github.com/search?q=lang%3ANix+GPUOffloadApp&type=code
let
  inherit (lib) getExe getExe';
  inherit (pkgs)
    coreutils
    gnused
    nvidia-offload
    runCommand
    ;
  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      runCommand "patched-desktop-entry-for-${appName}" { } ''
        ${getExe' coreutils "mkdir"} -p $out/share/applications
        ${getExe gnused} 's#${from}#${to}#g' \
          < ${pkg}/share/applications/${appName}.desktop \
          > $out/share/applications/${appName}.desktop
      ''
    );
  GPUOffloadApp =
    pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=${getExe nvidia-offload} ";
in
GPUOffloadApp
