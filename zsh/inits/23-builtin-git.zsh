function git() {
    if [ "$1" = clone ]; then
        # git clone and automatically cd
        {
            builtin cd "$(command git -c color.ui=always "$@" --progress 3>&1 1>&2 2>&3 3>&- |
                tee /dev/fd/3 |
                awk -F\' '/Cloning into/ {print $2}' |
                head -n 1)"
        } 3>&2 2>&1
    else
        command git "$@"
    fi
}
