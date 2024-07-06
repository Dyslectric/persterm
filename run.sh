#!/bin/bash

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dir|--directory)
      PERSTERM_DIR="$2"
      shift
      shift
      ;;
    -g|--group)
      SESSION_GROUP="$2"
      shift
      shift
      ;;
    -n|--name)
      SESSION_NAME="$2"
      shift
      shift
      ;;
  esac
done

FIRST_SESSION=$([[ -z "$(tmux list-sessions 2> /dev/null | grep "(group $SESSION_GROUP)")" ]] && echo true)

# Wait for a moment and then send a new-window command to the new session client
# if it is not the first session in the group
if [[ "$FIRST_SESSION" != "true" ]]; then
  sleep 0.01 &&
    tmux send-keys -K C-b ':' &&
    tmux send-keys -K 'new-window' C-m &
fi

[[ -z "$PERSTERM_DIR" ]] && PERSTERM_DIR="$HOME"

# Create a new session with the given group and session names
tmux -f "$HOME/.local/share/persterm/tmux.conf" \
  new-session \
  -c "$PERSTERM_DIR" \
  -t "$SESSION_GROUP" -s "$SESSION_NAME"

