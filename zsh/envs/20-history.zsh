# The maximum number of events stored in the internal history list.
HISTSIZE=2147483647

# The maximum number of history events to save in the history file.
SAVEHIST=2147483647

() {
    # Save history to Dropbox, if it's available.

    local dir="$HOME"/Dropbox/Settings

    if [ -d "$dir" ]; then
        dir="$dir/$(hostname-filename-safe)"

        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
        fi

        HISTFILE="$dir"/zsh-history

        if [ -f "${HOME}"/.zsh_history ]; then
            echo
            echo "[Alert] You have ~/.zsh_history but current HISTFILE is ${HISTFILE}."
            ls -lh "${HOME}"/.zsh_history
            echo "Consider merging them by running this:"
            echo "  $ fc -R ~/.zsh_history && fc -W && rm ~/.zsh_history"
            echo
        fi
    else
        HISTFILE="${HOME}"/.zsh_history
    fi
}
