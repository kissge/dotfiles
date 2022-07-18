() {
    if ! [ -d ~/Downloads ]; then
        return
    fi

    local old_files=$(
        cd ~/Downloads

        if (( ${+commands[powershell.exe]} )); then
            # WSL
            powershell.exe -Command 'Get-ChildItem | ? { $_.LastAccessTime -lt (Get-Date).AddDays(-3) }'
        elif command ls --color >/dev/null 2>&1; then
            # GNU
            find . -mindepth 1 -maxdepth 1 -atime +3 -exec ls --color=always -tdluh {} \+
        else
            # BSD
            find . -mindepth 1 -maxdepth 1 -atime +3 -exec env CLICOLOR=1 CLICOLOR_FORCE=1 ls -tdluh {} \+
        fi
    )

    if [ -n "$old_files" ]; then
        echo 'These file(s) have not been accessed for more than three days:' >&2
        echo "$old_files" >&2
        echo 'To delete these files, type `clean_older_files'"'"'.' >&2
    fi

    clean_older_files() {
        (
            cd ~/Downloads

            if (( ${+commands[powershell.exe]} )); then
                powershell.exe -Command 'Get-ChildItem |
                    ? { $_.LastAccessTime -lt (Get-Date).AddDays(-3) } |
                    Remove-Item -Recurse -Verbose'
            else
                find . -mindepth 1 -maxdepth 1 -atime +3 -exec rm -rfv {} \+ | command less -RFX
            fi
        )
    }
}
