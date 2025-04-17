{ pkgs, ... }:
let
  # https://github.com/joshmedeski/sesh/issues/87#issuecomment-2238078834
  seshTmuxScript = pkgs.writeShellScript "sesh_startup_script.sh" ''
    if [[ -e ".tmuxp.yaml" || -e ".tmuxp.yml" ]]; then
      tmuxp load -y .; exit
    fi
  '';
in
{
  programs.tmux = {
    enable = true;
    package = pkgs.wrappedPkgs.tmux;
  };
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
    enableTmuxIntegration = false;
    settings = {
      # TODO default_session is not working (not loading in new sesh sessions)
      default_session = {
        startup_command = "~/.config/sesh/sesh_startup_script.sh";
      };
    };
  };

  xdg.configFile."sesh/sesh_startup_script.sh".source = seshTmuxScript;

  programs.tmux.extraConfig = ''
    bind-key "g" run-shell "sesh connect \"$(
      sesh list --icons | fzf-tmux -p 80%,70% \
        --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
        --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
        --bind 'tab:down,btab:up' \
        --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
        --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
        --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
        --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
        --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
        --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
        --preview-window 'right:55%' \
        --preview 'sesh preview {}'
        -- --ansi
    )\""
  '';

  home.packages = [ pkgs.tmuxp ];
  # dmux
  # tmate?
}
