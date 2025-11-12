{ pkgs, ... }:
let
  # https://github.com/joshmedeski/sesh/issues/87#issuecomment-2238078834
  seshTmuxScript = pkgs.writeShellScript "sesh_startup_script.sh" ''
    if [[ -e ".tmuxp.yaml" || -e ".tmuxp.yml" ]]; then
      tmuxp load -y -a .; exit
    fi
  '';
in
{
  home.packages = [
    pkgs.wrappedPkgs.tmux
    pkgs.tmuxp
    pkgs.lazyPkgs.zellij
    pkgs.nurPkgs.tvmux
    # dmux
    # tmate?
  ];
  programs.tmux-aliases.enable = true;

  /*
    TODO when I know more about nix module system
    maybe a submodule type which can take in arbitrary inputs
    aliases.tmux = {
      pkg = pkgs.wrappedPkgs.tmux;
      t = "tmux";
      ta = "tmux a";
      at = "tmux a";
      tma = "tmux a";
    };
  */

  programs.sesh = {
    enable = true;
    # I copied what this flag does to my tmux.conf
    enableTmuxIntegration = false;
    settings = {
      default_session = {
        # previously startup_script, but now a silent breaking change
        startup_command = "~/.config/sesh/sesh_startup_script.sh";
      };
    };
  };

  xdg.configFile."sesh/sesh_startup_script.sh".source = seshTmuxScript;
}
