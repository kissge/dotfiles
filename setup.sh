#!/bin/bash
# shellcheck disable=SC2088

set -Eeuo pipefail

function exist() {
    command -v "$1" > /dev/null
}

function die() {
    echo $'[Error]\t'"$*" 1>&2
    exit 1
}

function yesno() {
    while :; do
        read -rp "$1 [y/n] " yn
        case $yn in
        [Yy]*) return 0 ;;
        [Nn]*) return 1 ;;
        esac
    done
}

if exist bat; then
    function show() {
        bat "$@"
    }
else
    function show() {
        less -RFX "$@"
    }
fi

echo '1. Checking required packages...'
for cmd in git zsh; do
    if ! exist $cmd; then
        die "$cmd is not installed"
    fi
done

echo '2. Checking existing rc files...'
for rc in ~/.zshrc ~/.zlogin ~/.zprofile; do
    if [ -f "$rc" ]; then
        show "$rc"
        if yesno "$rc already exists. Rename to $rc.bak?"; then
            mv -v "$rc" "$rc.bak"
        fi
    fi
done

if [ -f ~/.zshenv ]; then
    show ~/.zshenv
    if ! yesno '~/.zshenv already exists. Overwrite?'; then
        if yesno 'Rename to ~/.zshenv.bak?'; then
            mv -v ~/.zshenv ~/.zshenv.bak
        else
            die Aborting
        fi
    fi
fi

echo '3. Setting ~/.config up...'
tmpdir=$(mktemp -d)

if exist ssh.exe; then
    echo 'git clone using ssh.exe'
    GIT_SSH=ssh.exe git clone git@github.com:kissge/dotfiles.git "$tmpdir"
elif exist ssh; then
    echo 'git clone using ssh'
    git clone git@github.com:kissge/dotfiles.git "$tmpdir"
else
    echo 'git clone using https (ssh unavailable)'
    git clone https://github.com/kissge/dotfiles.git "$tmpdir"
fi

if [ -e ~/.config ]; then
    echo '~/.config already exists. Checking if possible to merge...'
    if (diff -qr "$tmpdir" ~/.config || true) | grep -v '^Only in'; then
        die Conflicting files
    fi

    echo 'No conflicts. Merging...'
    cd "$tmpdir"
    tar cBf - . | (cd ~/.config && tar xBvf -)
    cd -
    rm -rf "$tmpdir"
else
    mv -v "$tmpdir" ~/.config
fi

echo '4. Setting ~/.zshenv up...'
echo 'ZDOTDIR="${HOME}"/.config/zsh
source "$ZDOTDIR"/.zshenv' > ~/.zshenv

echo '5. Setting login shell...'
if [[ $SHELL =~ zsh$ ]]; then
    echo 'zsh is already your login shell'
else
    zsh_path=$(grep -m 1 -F /zsh /etc/shells)
    if yesno 'Use sudo? (chsh may require user password without sudo)'; then
        sudo chsh -s "$zsh_path" "$(whoami)"
    else
        chsh -s "$zsh_path"
    fi

    if [ -x /opt/distrod/bin/distrod ]; then
        sudo /opt/distrod/bin/distrod enable
    fi
fi

echo '6. Adding some finishing touches...'
mkdir -pv ~/git
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
    ln -vs ~/.config/git/{,.}wsl.inc
fi

if exist pacman; then
    if [ -f /etc/pacman.conf ]; then
        sed -E 's/#(Color)/\1/' /etc/pacman.conf > /tmp/pacman.conf
        if ! diff -q /etc/pacman.conf /tmp/pacman.conf > /dev/null; then
            diff -U 2 --color /etc/pacman.conf /tmp/pacman.conf
            if yesno 'Modify /etc/pacman.conf as shown above?'; then
                sudo tee /etc/pacman.conf < /tmp/pacman.conf > /dev/null
            fi
            rm -f /tmp/pacman.conf
        fi
    fi

    if [ -f /etc/makepkg.conf ]; then
        sed -E 's/(^OPTIONS=.* )(debug .*)/\1!\2/' /etc/makepkg.conf > /tmp/makepkg.conf
        if ! diff -q /etc/makepkg.conf /tmp/makepkg.conf > /dev/null; then
            diff -U 2 --color /etc/makepkg.conf /tmp/makepkg.conf
            if yesno 'Modify /etc/makepkg.conf as shown above?'; then
                sudo tee /etc/makepkg.conf < /tmp/makepkg.conf > /dev/null
            fi
            rm -f /tmp/makepkg.conf
        fi
    fi

    if ! exist yay && yesno 'Install yay?'; then
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay-bin.git ~/git/yay-bin
        cd ~/git/yay-bin
        makepkg -si
        cd -
    fi
fi

echo 'Completed!'
