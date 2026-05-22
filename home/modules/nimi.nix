{
  pkgs,
  config,
  flake-inputs,
  ...
}:
{
  imports = [
    flake-inputs.nimi.homeModules.default
  ];

  nimi.backrest = {
    services.backrest = {
      imports = [ pkgs.backrest.services.default ];
      backrest.dataDir = "${config.home.homeDirectory}/.local/share/backrest";
      backrest.configPath = "${config.home.homeDirectory}/.config/backrest/config.json";
    };
    settings.restart.mode = "up-to-count";
    settings.restart.time = 2000;
  };

  nimi.timetagger = {
    services.timetagger = {
      imports = [ pkgs.timetagger.services.default ];
    };
    settings.restart.mode = "up-to-count";
    settings.restart.time = 2000;
  };
}
