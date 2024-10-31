{ pkgs, ... }:
{
  xdg.configFile."hypr/hyprland.conf".source = ./config/hypr/hyprland.conf;
  xdg.configFile."hypr/monitors.conf".source = ./config/hypr/monitors.conf;
  xdg.configFile."hypr/workspaces.conf".source = ./config/hypr/workspaces.conf;
  /*
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${./config/wall.jpg}
      wallpaper = ,${./config/wall.jpg}
      ipc = off
    '';
  */
  xdg.configFile."waybar".source = ./config/waybar;
  xdg.configFile."wofi".source = ./config/wofi;
  home.packages = [
    pkgs.wl-clipboard-rs
    (pkgs.cliphist.overrideAttrs (_: {
      src = pkgs.fetchFromGitHub {
        owner = "sentriz";
        repo = "cliphist";
        rev = "v0.6.1";
        hash = "sha256-tImRbWjYCdIY8wVMibc5g5/qYZGwgT9pl4pWvY7BDlI=";
      };
      vendorHash = "sha256-gG8v3JFncadfCEUa7iR6Sw8nifFNTciDaeBszOlGntU=";
    }))
    pkgs.wofi
    pkgs.waybar
    #pkgs.hyprpaper
    pkgs.networkmanagerapplet
  ];
}
