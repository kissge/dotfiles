DOWNLOADS=${HOME}/Downloads/

if [ ! "$EMACS" -a -d "$DOWNLOADS" ]; then
    if find -atime +1d 2> /dev/null; then
        # BSD
        FINDCOMMAND="find $DOWNLOADS -maxdepth 1 -mindepth 1 -atime +3d"
    else
        # GNU
        FINDCOMMAND="find $DOWNLOADS -maxdepth 1 -mindepth 1 -atime +3"
    fi

    OLDERFILES=$($FINDCOMMAND -exec ls -tdlu {} \+)

    if [ -n "$OLDERFILES" ]; then
        echo 'These file(s) have not been accessed for more than three days:' >&2
        echo "$OLDERFILES" >&2
        echo 'To delete these files, type `clean_older_files'"'"'.' >&2
    fi

    function clean_older_files() {
        $FINDCOMMAND -exec rm -rfv {} \+ | command less -RFX
    }
fi
