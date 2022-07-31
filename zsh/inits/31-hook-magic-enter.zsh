function magic-enter() {
    if [[ -z $BUFFER && $CONTEXT == "start" ]]; then
        echo
        git status 2>/dev/null || ls
        echo $'\n'
        zle reset-prompt
    else
        zle accept-line
    fi
}

zle -N magic-enter
bindkey "^M" magic-enter
