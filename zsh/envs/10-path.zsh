function add_path() {
    if [ -d "$1" ]; then
        export PATH="$1:$PATH"
    fi
}

function deprioritize_fpath() {
    fpath=( ${fpath[@]:#"$1"} "$1" )
}

ZIM_HOME="${ZDOTDIR:-${HOME}}"/.zim

add_path "$HOME"/.config/bin
add_path "$HOME"/.config/bin/vendor
add_path "$HOME"/.local/bin
add_path "$ZIM_HOME/modules/iTerm2-shell-integration/utilities"

add_path /usr/local/bin

if (( ${+commands[brew]} )); then
    deprioritize_fpath "$(brew --prefix)"/share/zsh/site-functions
fi
