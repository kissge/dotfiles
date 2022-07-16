function __magic_enter_preexec() {
    previous_command="$1"
}

function __magic_enter_precmd() {
    if [[ -v previous_command ]] && [ -z "$previous_command" ]; then
        echo
        git status 2>/dev/null || ls
        echo
    fi

    previous_command=
}

autoload -Uz add-zsh-hook
add-zsh-hook -Uz preexec __magic_enter_preexec
add-zsh-hook -Uz precmd __magic_enter_precmd
