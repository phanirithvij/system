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


        # fish has alt+e or alt+v but I got used to bash binding
        # see bind --all and https://fishshell.com/docs/current/cmds/bind.html
        # implemented in fish-shell/fish-shell#3627
        bind ctrl-x,ctrl-e edit_command_buffer
      '';
  };
}
# fish plugins:
# - natural selection
# - omf?
# - babelfish (saw it in nix build log, maybe already exists)
