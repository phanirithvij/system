{ pkgs, ... }:
{
  environment.packages = with pkgs; [ mosh ];
}
