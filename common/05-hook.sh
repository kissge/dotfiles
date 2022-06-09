#!/bin/sh

_DOWNLOADS="${HOME}/Downloads"

if [ ! "$EMACS" ] && [ -d "$_DOWNLOADS" ]; then
    OLDERFILES=$(
        cd "$_DOWNLOADS"

        if powershell.exe -h >/dev/null 2>&1; then
            powershell.exe -Command 'Get-ChildItem | ? { $_.LastAccessTime -lt (Get-Date).AddDays(-3) }'
        elif command ls --color >/dev/null 2>&1; then
            find . -mindepth 1 -maxdepth 1 -atime +3 -exec ls --color=always -tdluh {} \+
        else
            find . -mindepth 1 -maxdepth 1 -atime +3 -exec env CLICOLOR=1 CLICOLOR_FORCE=1 ls -tdluh {} \+
        fi
    )
    # 'if' above = GNU or BSD check (why can't I write comment inside $()?)

    if [ -n "$OLDERFILES" ]; then
        echo 'These file(s) have not been accessed for more than three days:' >&2
        echo "$OLDERFILES" >&2
        echo 'To delete these files, type `clean_older_files'"'"'.' >&2
    fi

    unset OLDERFILES

    clean_older_files() {
        (
            cd "$_DOWNLOADS"
            if powershell.exe -h >/dev/null 2>&1; then
                powershell.exe -Command 'Get-ChildItem |
                    ? { $_.LastAccessTime -lt (Get-Date).AddDays(-3) } |
                    Remove-Item -Recurse -Verbose'
            else
                find . -mindepth 1 -maxdepth 1 -atime +3 -exec rm -rfv {} \+ | command less -RFX
            fi
        )
    }
fi

if test "$__WSL"; then
    grep -q automatic /etc/resolv.conf || echo '[Alert] /etc/resolv.conf might be broken?'
fi
