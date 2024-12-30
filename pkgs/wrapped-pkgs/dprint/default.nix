{ pkgs, ... }:
{
  wrappers.dprint = {
    basePackage = pkgs.dprint;
    appendFlags =
      [
        "--plugins"
      ]
      ++ builtins.map toString (
        with pkgs.dprint-plugins;
        [
          dprint-plugin-markdown
          dprint-plugin-toml
          dprint-plugin-json
          g-plane-pretty_yaml
        ]
      );
  };
}
