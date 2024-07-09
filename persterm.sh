#!/bin/bash -x

showhelp() {
  echo ""
  cat $HOME/.local/share/persterm/help.txt
  echo ""
}

PERSTERM_SHARE_HIST="true"

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
    --share-history)
      PERSTERM_SHARE_HIST="$2"
      shift
      shift
      ;;
    *)
      echo "persterm: invalid option: $2"
      shift
      ;;
  esac
done

# Get the $USER session group if group not defined with argument
[[ -z "$SESSION_GROUP" ]] && SESSION_GROUP="$USER"

# Get a random session name if name not defined with argument
[[ -z "$SESSION_NAME" ]] && SESSION_NAME=$(uuidgen | cut -c1-8)

persterm_init () {
  SESSION_NAME="$1"
  SESSION_GROUP="$2"
  PERSTERM_SHARE_HIST="$3"
  PERSTERM_DIR="$4"

  FIRST_SESSION=$([[ -z "$(tmux list-sessions 2> /dev/null | grep "(group $SESSION_GROUP)")" ]] && echo true)

  SHELL_COMMAND='bash --rcfile <(cat "$HOME/.bashrc" "$HOME/.local/share/persterm/bashrc.sh")'
  
  # Wait for a moment and open a new window with the desired shell command
  if [[ "$FIRST_SESSION" != "true" ]]; then
    sleep 0.01 &&
      tmux send-keys -K C-b ':' &&
      tmux send-keys -K "new-window '$SHELL_COMMAND'" C-m &
  fi
  
  [[ -z "$PERSTERM_DIR" ]] && PERSTERM_DIR="$HOME"
  
  # Create a new session with the given session name and attach it to group
  tmux -f "$HOME/.local/share/persterm/tmux.conf" \
    new-session \
    -e PERSTERM_SHARE_HIST="$PERSTERM_SHARE_HIST" \
    -t "$SESSION_GROUP" \
    -c "$PERSTERM_DIR" \
    -s "${SESSION_NAME}"
}

if [[ $SPAWN == "true" ]]; then
  if [[
    "$TERMINAL" == "alacritty" ||
      "$TERMINAL" == "wezterm" ||
      "$TERMINAL" == "st" ||
      "$TERMINAL" == "kgx" ||
      "$TERMINAL" == "konsole" ||
      "$TERMINAL" == "kitty"
        ]];
  then
    
    $TERMINAL \
      $([[ "$TERMINAL" == "kitty" ]] && echo "-c $HOME/.local/share/persterm/kitty.conf") \
      -e bash \
      --rcfile <(cat "$HOME/.bashrc" "$HOME/.local/share/persterm/bashrc.sh") \
      -ic \
      "$(declare -f persterm_init) ; \
      persterm_init $SESSION_NAME $SESSION_GROUP $PERSTERM_SHARE_HIST $PERSTERM_DIR" ;
      #exit

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
  persterm_init $SESSION_NAME $SESSION_GROUP $PERSTERM_SHARE_HIST $PERSTERM_DIR
fi

