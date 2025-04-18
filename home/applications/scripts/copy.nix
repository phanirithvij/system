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
    (pkgs.writeShellScriptBin "paste" ''
      if [ -n "$WAYLAND_DISPLAY" ]; then
        ${pkgs.lib.getExe pkgs.wl-clipboard-rs} -o -sel clip
      else
        ${pkgs.lib.getExe pkgs.xclip} -o -sel clip
      fi
    '')
  ];
}
