#!/bin/sh

DOWNLOADS=${HOME}/Downloads/

if [ ! "$EMACS" ] && [ -d "$DOWNLOADS" ]; then
    # shellcheck disable=SC2185
    if find -atime +1d 2>/dev/null; then
        # BSD
        FINDCOMMAND="find $DOWNLOADS -maxdepth 1 -mindepth 1 -atime +3d"
    else
        # GNU
        FINDCOMMAND="find $DOWNLOADS -maxdepth 1 -mindepth 1 -atime +3"
    fi

    OLDERFILES=$(eval "$FINDCOMMAND" -exec ls -tdlu {} \+)

    if [ -n "$OLDERFILES" ]; then
        echo 'These file(s) have not been accessed for more than three days:' >&2
        echo "$OLDERFILES" >&2
        echo 'To delete these files, type `clean_older_files'"'"'.' >&2
    fi

    clean_older_files() {
        eval "$FINDCOMMAND" -exec rm -rfv {} \+ | command less -RFX
    }
fi

if test "$__WSL"; then
    grep -q automatic /etc/resolv.conf || echo '[Alert] /etc/resolv.conf might be broken?'
fi
