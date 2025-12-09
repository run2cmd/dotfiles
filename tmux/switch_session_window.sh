#!/usr/bin/env bash

function main() {
  local windows fzf_command

  fzf_command=(fzf --exit-0 --print-query --reverse --delimiter=":" --with-nth=1,2,3,4)
  windows=$(tmux list-windows -a -F "#{session_name}:#{window_index}:#{window_name}" | "${fzf_command[@]}")
  retval=$?

  IFS=$'\n' read -rd '' -a win_arr <<<"$windows"
  window="${win_arr[1]}"
  query="${win_arr[0]}"

  if [ $retval -eq 0 ]; then
    if [ -z "$window" ]; then
      window="$query"
    fi
    session_window=(${window//:/ })
    tmux switch-client -t "${session_window[0]}:${session_window[1]}"
  elif [ $retval -eq 1 ]; then
    tmux command-prompt -b "Window does not exists"
  fi
}

main
