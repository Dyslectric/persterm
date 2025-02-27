# Persterm: The Persistent Terminal

<picture>
 <source media="(prefers-color-scheme: dark)" srcset="persterm-logo.png">
 <source media="(prefers-color-scheme: light)" srcset="persterm-logo.png">
 <img alt="YOUR-ALT-TEXT" src="YOUR-DEFAULT-IMAGE">
</picture>

Persterm is a small application that runs alongside common terminal emulators
and with configured tmux sessions and session groups. Multiple terminal window
workflows (especially when applied to multiple monitors) are made more flexible
with the ability to freely spawn new gui windows with a new shell inside of a
tmux session group.

## Installation 

Local user installation is easy and distro-independent as long as you are using
bash. Four easy commands:

```
git clone https://github.com/dyslectric/persterm
cd persterm
chmod +x install.sh
./install.sh
```

## Usage

Usage details can be found by running ```persterm --help```: 

```
Usage: persterm [options]

  -s, --spawn                        open the session in a new $TERMINAL window
  -d, --dir, --directory=DIRECTORY   open the new shell in the given directory
  -g, --group=TMUX_SESSION_GROUP     set the group that the new session will belong to
  -n, --name=TMUX_SESSION_NAME       set the name of the new session
  -h, --help                         display this help message and exit

If run without any options, a new tmux session will be created in the session
group: $USER, with a new shell opened in the $HOME directory.

The desktop application will open a new shell window in the $USER session group
in the $HOME directory. The session name will be a random string.

Default binds: Uses default tmux binds with the following additions:

  C-b C-n: New terminal emulator window with new tmux window in current session
  group with new shell instance
```

## Configuration

Files and scripts utilized by the applications can be found in your
~/.local/share/persterm/ directory. The files include:
  - bashrc.sh: an init hook sourced alongside your default .bashrc
    - by default includes tmux window renaming functionality for bash
  - tmux.conf: the configuration persterm uses when running tmux
    - persterm does not load your default ~/.tmux.conf file
  - Specific terminal configurations (I don't want to have to use these, but if
  I must, I will do my best to load default configurations alongside the
  persterm-specific functionality.):
    - kitty.conf
    - alacritty.toml
    - etc.

## Current Features

- Install local bin into .bashrc PATH
- Bash renames tmux window to working directory basename
- Custom tmux interface configuration
- Tmux hotkey for opening new terminal emulator window with new shell in tmux
group
- User-wide tmux session group freedesktop application entry
- Currently supports the following terminal emulators: (uses $TERMINAL)
    - Kitty
    - Alacritty
    - Wezterm
    - st
    - kgx (Gnome Console)
    - konsole (KDE Default)
- Share bash histories by default (turn off with ```--share-history false```)

## Planned Features

- Make app work with any terminal emulator (or at least all common ones)
- Allow use of alternative shells (zsh, fish, powershell, etc.)
- Allow for quick creation of XDG Desktop entries for project workspaces
  - Perhaps use a command like ```persterm-workspace```

## Known Bugs and Issues

- Wezterm closes the tmux window that it is focussed on when it closes (I am not
sure how to fix this behavior)
  - This doesn't happen if something is running in the window. This is cool but
  it would be nice if there was a way to make it not happen at all
- Kitty won't let you close the terminal immediately by default, should be
fixable with configuration (fixed [c136725](https://github.com/Dyslectric/persterm/commit/c136725f281e6c35e0b2b35ed3b284fd0ffe5444))
- If a new terminal emulator window is created at a different buffer size than
the one that the window it opens to initially, it will change the size of the
window.

