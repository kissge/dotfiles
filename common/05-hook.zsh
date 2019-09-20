# original source: https://superuser.com/a/625663
function magic-enter() {
    if [ -z "$BUFFER" ]; then
        echo
        git status 2> /dev/null || ls --color
        echo $'\n'
        zle reset-prompt
    else
        zle accept-line
    fi
}
zle -N magic-enter
bindkey "^M" magic-enter
