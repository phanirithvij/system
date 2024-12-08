{ wrappedPkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    package = wrappedPkgs.wezterm;
  };
}
