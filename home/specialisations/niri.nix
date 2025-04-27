{ lib, ... }:
{
  services.espanso = {
    x11Support = lib.mkForce false;
    waylandSupport = lib.mkForce true;
  };
}
