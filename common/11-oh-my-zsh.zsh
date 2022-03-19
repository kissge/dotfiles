# shellcheck shell=bash

function oh-my-zsh() {
    export ZSH=${HOME}/.oh-my-zsh
    source "$ZSH"/oh-my-zsh.sh

    # see 03-builtin.sh
    unalias md
}
