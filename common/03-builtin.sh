function md() {
    mkdir -p "$1" && builtin cd "$1" && pwd
}

function cd() {
    # Get last argument
    local LAST=${@:$#}

    if [ -f "$LAST" ]; then
        builtin cd "${@:1:$(($# - 1))}" "$(dirname -- "$LAST")"
    else if [ -d "$LAST" ]; then # redundant?
             builtin cd "$@"
         else
             local CDPATH="$__CDPATH"
             builtin cd "$@"
         fi
    fi
}
