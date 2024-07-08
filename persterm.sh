#!/bin/bash

showhelp() {
  echo ""
  cat $HOME/.local/share/persterm/help.txt
  echo ""
}

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
    -h|--help)
      showhelp
      exit
      ;;
    -s|--spawn)
      SPAWN="true"
      shift
      ;;
  esac
done

# Get the $USER session group if group not defined with argument
[[ -z "$SESSION_GROUP" ]] && SESSION_GROUP="$USER"

# Get a random session name if name not defined with argument
[[ -z "$SESSION_NAME" ]] && SESSION_NAME=$(uuidgen | cut -c1-8)

runcommand="$HOME/.local/share/persterm/run.sh -n $SESSION_NAME -g $SESSION_GROUP "

[[ -n "$PERSTERM_DIR" ]] && runcommand+="-d $PERSTERM_DIR "

persterm_init () {
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
}

if [[ $SPAWN == "true" ]]; then
  if [[
    "$TERMINAL" == "kitty" ||
      "$TERMINAL" == "alacritty" ||
      "$TERMINAL" == "wezterm" ||
      "$TERMINAL" == "st" ||
      "$TERMINAL" == "kgx" ||
      "$TERMINAL" == "konsole"
        ]];
  then
    $TERMINAL -e bash -ic "$(declare -f persterm_init) ; persterm_init -g $SESSION_GROUP -n $SESSION_NAME -d $PERSTERM_DIR" ; exit
  else
    echo '$TERMINAL is not defined as one of the following:'
    echo '  - ' 'kitty'
    echo '  - ' 'alacritty'
    echo '  - ' 'wezterm'
    echo '  - ' 'st'
    echo '  - ' 'kgx        (Gnome Console)'
    echo '  - ' 'konsole    (KDE Default)'
  fi
else
  persterm_init
fi

