DOWNLOADS=${HOME}/Downloads

if [ ! "$EMACS" -a -d "$DOWNLOADS" ]; then
    OLDERFILES=$(find "$DOWNLOADS" -maxdepth 1 -atime +3d -exec ls -tdlu {} \+)

    if [ -n "$OLDERFILES" ]; then
        echo 'These file(s) have not been accessed for more than three days:' >&2
        echo "$OLDERFILES" >&2
        echo 'To delete these files, type `clean_older_files'"'"'.' >&2
    fi

    function clean_older_files() {
        find "$DOWNLOADS" -maxdepth 1 -atime +3d -exec rm -rfv {} \+ | command less -RFX
    }
fi
