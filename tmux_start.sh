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
        title=$(echo "$window" | sed -E 's/\[.*\]//g')
        cmd=$(echo "$window" | sed -n 's/.*\[\([^]]*\)\].*/\1/p')
        [ -z "$cmd" ] && cmd="bash"
        if [ $window_index -eq 0 ]; then
          tmux new-session -d -s "$name" -n "$title" -c "$session_path" "$cmd"
        else
          tmux new-window -t "$name:" -n "$title" -c "$session_path" "$cmd"
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
  first_session="${1%%:*}"
  session_name=$(basename "$first_session")
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
