{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.neovim-nvf;
in
{
  options.programs.neovim-nvf = {
    enable = lib.mkEnableOption "Use neovim via nvf from nur pkgs" // {
      default = true;
    };
    package = lib.mkPackageOption pkgs [ "nurPkgs" "flakePkgs" "nvf" ] { };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    home.sessionVariables.EDITOR = lib.mkForce "nvim";
  };
}
