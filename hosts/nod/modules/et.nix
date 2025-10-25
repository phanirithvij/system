{ pkgs, ... }:
{
  environment.packages = with pkgs; [ eternal-terminal ];
}
