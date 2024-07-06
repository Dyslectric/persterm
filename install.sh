#!/bin/bash

mkdir -p ~/.local/share/persterm
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/bin

cp alacritty.toml bashrc.sh run.sh tmux.conf help.txt ~/.local/share/persterm/
cp persterm.sh ~/.local/bin/persterm
cp persterm-spawn.sh ~/.local/bin/persterm-spawn
cp persterm.desktop ~/.local/share/applications/

chmod +x ~/.local/share/persterm/run.sh
chmod +x ~/.local/bin/persterm

if [[ -z "$(grep 'export.*~/.local/bin' <(echo $PATH))" ]]; then
  echo 'Adding local bin path to PATH in HOME .bashrc'
  echo '# Added by persterm' >> ~/.bashrc
  echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
fi

