{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lazydocker
    docker-compose
    # TODO docker tools
    # grype, dive
  ];
}
