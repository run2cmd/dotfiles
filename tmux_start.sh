#!/bin/bash

detached_session() {
  for session_dir in "$@" ;do
    name=${session_dir//*\//}
    if ! tmux has-session -t "${name}" 2>/dev/null; then
      tmux new-session -d -s "${name}" -c "${session_dir}"
    fi
  done
}

start_sessions() {
  detached_session "$@"
  tmux attach-session -t "${1//*\//}"
}

if [ "$*" != "" ] ;then
  tmux "$@"
elif [ ! -z "$TMUX_START_SESSIONS" ] ;then
  start_sessions $TMUX_START_SESSIONS
else
  tmux
fi
