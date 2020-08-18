function md() {
    mkdir -p "$1" && builtin cd "$1" && pwd
}

function cd() {
    # Get last argument
    local LAST=${@:$#}

    if [ -f "$LAST" ]; then
        builtin cd "${@:1:$(($# - 1))}" "$(dirname -- "$LAST")"
    elif [ -d "$LAST" ]; then # redundant?
        builtin cd "$@"
    elif [ "$#" -ne 0 ] && which wslpath > /dev/null 2>&1; then
        builtin cd "$(wslpath "$@")"
    else
        local CDPATH="$__CDPATH"
        builtin cd "$@"
    fi
}

function @exist() {
  which "$1" > /dev/null 2>&1
}
