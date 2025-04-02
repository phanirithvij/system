{ lib, ... }:
{
  specialisation.niri = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:niri" ];
      desktopManagers.niri.enable = true;
      desktopManagers.xfce.enable = lib.mkForce false;
      nix.settings.substituters = [
        "https://niri.cachix.org"
      ];
      nix.settings.trusted-public-keys = [
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
  };
}
