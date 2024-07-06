#!/bin/bash

declare -A files_map

files_map["./persterm.sh"]="$HOME/.local/bin/persterm"
files_map["./persterm-spawn.sh"]="$HOME/.local/bin/persterm-spawn"
files_map["./persterm.desktop"]="$HOME/.local/share/applications/persterm.desktop"
files_map["./run.sh"]="$HOME/.local/share/persterm/run.sh"
files_map["./bashrc.sh"]="$HOME/.local/share/persterm/bashrc"
files_map["./tmux.conf"]="$HOME/.local/share/persterm/tmux.conf"
files_map["./alacritty.toml"]="$HOME/.local/share/persterm/alacritty.toml"
files_map["./help.txt"]="$HOME/.local/share/persterm/help.txt"

inotifywait -m -e create,modify . --format "%w%f" |
while read FILE; do
  for SRC_PATH in "${!files_map[@]}"; do
    if [[ "$FILE" == "$SRC_PATH" ]]; then
      echo "Copying $FILE to ${files_map[$FILE]}"
      cp "$FILE" "${files_map[$FILE]}"
      [[ "${files_map[$FILE]}" =~ "$HOME/.local/bin/" ]] && chmod +x "${files_map[$FILE]}"
    fi
  done
  
done

wait

