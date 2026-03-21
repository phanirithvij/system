{
  flake-inputs,
  pkgs,
  ...
}:
{
  imports = [
    flake-inputs.nimi.homeModules.default
  ];

  nimi.timetagger = {
    services.timetagger = {
      imports = [ pkgs.timetagger.services.default ];
    };
    settings.restart.mode = "up-to-count";
    settings.restart.time = 2000;
  };
}
