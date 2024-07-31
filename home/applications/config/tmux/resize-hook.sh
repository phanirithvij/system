#!/usr/bin/env sh
window_zoomed_flag=$(tmux display-message -p '#{window_zoomed_flag}')
#prev_zoomed_flag=$(cat ~/.tmux/.zoomed_flag)
prev_zoomed_flag=$(redis-cli get tmux_zoomed)
if [ "$window_zoomed_flag" != "$prev_zoomed_flag" ]; then
  tmux set-option -g status
  #echo $window_zoomed_flag > ~/.tmux/.zoomed_flag
  redis-cli set tmux_zoomed "$window_zoomed_flag" >/dev/null
fi
