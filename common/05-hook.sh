#!/bin/sh

_DOWNLOADS="${HOME}/Downloads"

if [ ! "$EMACS" ] && [ -d "$_DOWNLOADS" ]; then
    if command ls --color >/dev/null 2>&1; then
        # GNU
        _LS_COMMAND='ls --color=always'
    else
        # BSD
        _LS_COMMAND='env CLICOLOR=1 CLICOLOR_FORCE=1 ls'
    fi

    OLDERFILES=$(
        cd "$_DOWNLOADS"
        find . -mindepth 1 -maxdepth 1 -atime +3 -exec "$_LS_COMMAND" -tdluh {} \+
    )

    if [ -n "$OLDERFILES" ]; then
        echo 'These file(s) have not been accessed for more than three days:' >&2
        echo "$OLDERFILES" >&2
        echo 'To delete these files, type `clean_older_files'"'"'.' >&2
    fi

    unset OLDERFILES

    clean_older_files() {
        (
            cd "$_DOWNLOADS"
            find . -mindepth 1 -maxdepth 1 -atime +3 -exec rm -rfv {} \+ | command less -RFX
        )
    }
fi

if test "$__WSL"; then
    grep -q automatic /etc/resolv.conf || echo '[Alert] /etc/resolv.conf might be broken?'
fi
