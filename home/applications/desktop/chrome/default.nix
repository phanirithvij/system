{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lazyPkgs.ungoogled-chromium
    # TODO lazy brave, unfree chrome, edge etc.
    # wait for servo and ladybird and maybe one day google will die
  ];
}
