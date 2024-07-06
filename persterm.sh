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
  esac
done

# Get the $USER session group if group not defined with argument
[[ -z "$SESSION_GROUP" ]] && SESSION_GROUP="$USER"

# Get a random session name if name not defined with argument
[[ -z "$SESSION_NAME" ]] && SESSION_NAME=$(uuidgen | cut -c1-8)

runcommand="~/.local/share/persterm/run.sh -n $SESSION_NAME -g $SESSION_GROUP "

[[ -n "$PERSTERM_DIR" ]] && runcommand+="-d $PERSTERM_DIR "

if [[
  "$TERMINAL" == "kitty" ||
    "$TERMINAL" == "alacritty" ||
    "$TERMINAL" == "wezterm" ||
    "$TERMINAL" == "st"
      ]];
then
  $TERMINAL -e bash -ic "$runcommand" ; exit
else
  echo '$TERMINAL is not defined as one of the following:'
  echo '  - ' 'kitty'
  echo '  - ' 'alacritty'
  echo '  - ' 'wezterm'
  echo '  - ' 'st'
fi

