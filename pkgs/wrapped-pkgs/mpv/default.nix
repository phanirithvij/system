{ pkgs, ... }:
{
  wrappers.mpv = {
    # https://github.com/NixOS/nixpkgs/pull/304349#issuecomment-2164006511
    # https://github.com/NixOS/nixpkgs/pull/304349#issuecomment-2163675387
    basePackage = pkgs.mpv.override {
      scripts = with pkgs.mpvScripts; [
        # TODO sponsorblock, yt-dlp etc.
        thumbfast
        uosc
      ];
    };
    flags = [
      "--config-dir=${./config}"
    ];
  };
}
