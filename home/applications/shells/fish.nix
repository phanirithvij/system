_: {
  programs.fish = {
    enable = true;
    interactiveShellInit =
      # bash
      ''
        # disable greet message
        set fish_greeting

        abbr -a -p anywhere L --set-cursor '%| less'

        # https://fishshell.com/docs/current/cmds/abbr.html
        function last_history_item
            echo $history[1]
        end
        abbr -a -p anywhere !! --function last_history_item

        # https://superuser.com/a/1762626
        function last_history_token
            echo $history[1] | read -t -a tokens
            echo $tokens[-1]
        end
        abbr -a -p anywhere !\$ --function last_history_token
      '';
  };
}
# fish plugins:
# - natural selection
# - omf?
# - babelfish (saw it in nix build log, maybe already exists)
