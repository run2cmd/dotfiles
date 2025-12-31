#!/bin/bash

detached_session() {
  for session_dir in "$@"; do
    session_path="${session_dir%%:*}"
    windows_list="${session_dir#*:}"
    [ "$session_path" = "$session_dir" ] && windows_list=""
    name=$(basename "$session_path")
    tmux has-session -t "$name" 2>/dev/null && continue
    if [ -n "$windows_list" ]; then
      window_index=0
      for window in $(echo "$windows_list" | tr -s ':' ' '); do
        if [ $window_index -eq 0 ]; then
          tmux new-session -d -s "$name" -n "$window" -c "$session_path"
        else
          tmux new-window -t "$name:" -n "$window" -c "$session_path"
        fi
        window_index=$((window_index + 1))
      done
    else
      tmux new-session -d -s "$name" -c "$session_path"
    fi
  done
}

start_sessions() {
  detached_session "$@"
  active_session=$(echo "$1" | cut -d ':' -f1 | xargs)
  active_window=$(echo "$1" | cut -d ':' -f2 | xargs)
  session_name=$(basename "$active_session")
  tmux select-window -t "$session_name:$active_window"
  tmux attach-session -t "$session_name"
}

if [ "$*" != "" ] ;then
  tmux "$@"
elif [ ! -z "$TMUX_START_SESSIONS" ] ;then
  IFS=$'\n' read -rd '' -a session_array <<< "$TMUX_START_SESSIONS"
  start_sessions "${session_array[@]}"
else
  tmux
fi
