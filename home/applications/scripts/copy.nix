{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "copy" ''
      if [ -n "$WAYLAND_DISPLAY" ]; then
        ${pkgs.lib.getExe pkgs.wl-clipboard-rs} -sel clip
      else
        ${pkgs.lib.getExe pkgs.xclip} -sel clip
      fi
    '')
  ];
}
