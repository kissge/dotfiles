function md() {
    mkdir -p "$1" && builtin cd "$1" && pwd
}

function cd() {
    if [ $# -eq 0 ]; then
        local git_root

        if ! git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
            # Not inside a git repo, so fallback to ~/
            builtin cd
        elif [ "$git_root" != "$PWD" ] || git_root=$(cd .. && git rev-parse --show-toplevel 2>/dev/null); then
            # Found git root
            builtin cd "$git_root"
        else
            # Now at git root, which is the only one under ~/ or /, so fallback to ~/
            builtin cd
        fi
    else
        local last_arg="${@:$#}"

        if [ -f "$last_arg" ]; then
            # File is given, cd to its directory
            builtin cd "${@:1:$(($# - 1))}" "$(dirname -- "$last_arg")"
        else
            builtin cd "$@"
        fi
    fi
}
