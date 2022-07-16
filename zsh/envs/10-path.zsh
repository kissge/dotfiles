function add_path() {
    if [ -d "$1" ]; then
        export PATH="$1:$PATH"
    fi
}

add_path "$HOME"/.config/bin
add_path "$HOME"/.config/bin/vendor
