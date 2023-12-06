() {
    if ! [ -d ~/Downloads ]; then
        return
    fi

    local old_files=(${(0)"$(
        cd ~/Downloads
        find . -mindepth 1 -maxdepth 1 -atime +3 -print0
        # A bit hacky, but on NTFS, last access time cannot be simply queried against folders.
        find . -maxdepth 1 -type d -exec \
            zsh -c '[[ -n $(find "$1" -type f -atime -3 -print -quit) ]] || printf %s\\0 "$1"' zsh {} \;
    )"})

    if [ -n "$old_files" ]; then
        echo 'These file(s) have not been accessed for more than three days:'
        (
            cd ~/Downloads
            ls -tdluh "$old_files[@]"
        )
        echo 'To delete these files, type `clean_older_files'"'"'.'

        eval "clean_older_files() {
            (
                cd ~/Downloads
                rm -rfv ${(q)old_files[@]} | less -RFX
            )
        }"
    fi
} >&2
