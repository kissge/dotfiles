# shellcheck shell=bash

HISTSIZE=2147483647
# shellcheck disable=SC2034
SAVEHIST=2147483647

if [ -d "${HOME}/Dropbox/Settings" ]; then
    HISTFILE="${HOME}/Dropbox/Settings/$(hostname | sed -e 's/[^A-Za-z0-9._-]/_/g').zsh-history"

    if [ -f "${HOME}/.zsh_history" ]; then
        echo
        echo "[Alert] You have ~/.zsh_history but current HISTFILE is ${HISTFILE}."
        ls -lh "${HOME}/.zsh_history"
        echo "Consider:"
        echo "  $ fc -R ~/.zsh_history && fc -W && rm ~/.zsh_history"
        echo
    fi
fi
