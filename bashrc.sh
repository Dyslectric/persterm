set_tmux_window_title() {
    local dir_name=$(basename "$PWD")
    tmux rename-window "💻 bash - $dir_name"
    printf "\033]2;%s\033\\" "$dir_name"
}

PROMPT_COMMAND="set_tmux_window_title; $PROMPT_COMMAND"

[[ "$PERSTERM_SHARE_HIST" == "true" ]] && PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

