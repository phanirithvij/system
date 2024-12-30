{ pkgs, ... }:
pkgs.dprint-plugins.mkDprintPlugin {
  description = "Format Lua code through dprint using StyLua";
  hash = "sha256-atCb2iS7TJhiX3w5ngf9gmMe3RgghR3MSykwHPxbYLk=";
  initConfig = {
    configExcludes = [ ];
    configKey = "stylua";
    fileExtensions = [
      "lua"
    ];
  };
  pname = "dprint-plugin-stylua";
  updateUrl = "https://plugins.dprint.dev/RubixDev/stylua/latest.json";
  url = "https://plugins.dprint.dev/RubixDev/stylua-v0.2.1.wasm";
  version = "0.2.1";
  license = pkgs.lib.licenses.gpl3Plus;
  maintainers = [ ];
}
