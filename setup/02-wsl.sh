if exist powershell.exe; then
    windows_home=$(wslpath "$(powershell.exe '$env:UserProfile')")
    if [ ! -e ~/Downloads ] && [ -e "$windows_home/Downloads" ]; then
        ln -vs "$windows_home/Downloads" ~/
    fi

    if [ ! -e ~/Dropbox ]; then
        # https://help.dropbox.com/installs/locate-dropbox-folder
        if dropbox_windows_path=$(powershell.exe '
            Get-Content "$env:LOCALAPPDATA\Dropbox\info.json" -ErrorAction Stop |
                ConvertFrom-Json | % personal | % path |
                Write-Host -NoNewline' 2> /dev/null); then
            ln -vs "$(wslpath "$dropbox_windows_path")" ~/Dropbox
        fi
    fi
fi

if exist ssh.exe; then
    ln -vsf ~/.config/git/{,.}wsl.inc
fi
