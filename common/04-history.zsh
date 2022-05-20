# shellcheck shell=bash

HISTSIZE=2147483647
# shellcheck disable=SC2034
SAVEHIST=2147483647

DIR="$HOME/Dropbox/Settings"

if [ -d "$DIR" ]; then
    DIR="$DIR/$(hostname-filename-safe)"
    if [ ! -d "$DIR" ]; then
        mkdir -p "$DIR"
    fi
    HISTFILE="$DIR/zsh-history"

    if [ -f "${HOME}/.zsh_history" ]; then
        echo
        echo "[Alert] You have ~/.zsh_history but current HISTFILE is ${HISTFILE}."
        ls -lh "${HOME}/.zsh_history"
        echo "Consider:"
        echo "  $ fc -R ~/.zsh_history && fc -W && rm ~/.zsh_history"
        echo
    fi
fi
