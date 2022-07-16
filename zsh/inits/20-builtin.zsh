function md() {
    mkdir -p "$1" && builtin cd "$1" && pwd
}

function cd() {
    if [ $# -eq 0 ]; then
        local git_root
        if git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
            if [ "$git_root" != "$PWD" ]; then
                builtin cd "$git_root"
                return
            fi
        fi

        builtin cd
        return
    fi

    local last_arg="${@:$#}"

    if [ -f "$last_arg" ]; then
        builtin cd "${@:1:$(($# - 1))}" "$(dirname -- "$last_arg")"
    else
        builtin cd "$@"
    fi
}
