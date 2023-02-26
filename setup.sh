#!/bin/bash

set -Eeuo pipefail

function exist() {
    which "$1" >/dev/null 2>&1
}

function die() {
    echo $'[Error]\t'"$@" 1>&2
    exit 1
}

function yesno() {
    while :; do
        read -p "$1 [y/n] " yn
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

if ! exist ssh; then
    echo "Warning: ssh is not installed; git clone using SSH is likely to fail."
fi

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

if exist ssh-keygen && ! ls ~/.ssh/*.pub >/dev/null 2>&1; then
    if yesno 'Run `ssh-keygen -t ed25519`?'; then
        ssh-keygen -t ed25519
    fi
fi

if yesno 'git clone using SSH, not HTTPS?'; then
    git clone git@github.com:kissge/dotfiles.git "$tmpdir"
else
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
source "$ZDOTDIR"/.zshenv' >~/.zshenv

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
    windows_home=/mnt/c/Users/$(powershell.exe 'Write-Host -NoNewline $env:UserName')
    if [ ! -e ~/Downloads ] && [ -e "$windows_home/Downloads" ]; then
        ln -vs "$windows_home/Downloads" ~/
    fi

    if [ ! -e ~/Dropbox ] && [ -e "$windows_home/Dropbox" ]; then
        ln -vs "$windows_home/Dropbox" ~/
    fi
fi

echo 'Completed!'
