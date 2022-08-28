#!/bin/bash

set -Eeuo pipefail

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

if which bat >/dev/null 2>&1; then
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
    if ! which $cmd >/dev/null 2>&1; then
        die "$cmd is not installed"
    fi
done

if ! which ssh >/dev/null 2>&1; then
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
    chsh -s $(which zsh)
fi

echo 'Completed!'
