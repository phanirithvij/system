{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    a-keys-path # gmtk2020 winner
    (
      if pkgs ? honey-home then
        throw "honey-home is now available in nixpkgs, remove the local thing in pkgs/binary"
      else
        binaryPkgs.honey-home # ld38 winner
    )
    oh-my-git
  ];
  programs.steam.enable = true;
}
