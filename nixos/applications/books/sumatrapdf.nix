{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.sumatrapdf
  ];
}
