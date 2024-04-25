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

if [ -d ~/.config/.git ]; then
    echo '~/.config already exists and appears to be a git repository. Leaving as is.'
else
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
fi

echo '4. Setting ~/.zshenv up...'
echo 'ZDOTDIR="${HOME}"/.config/zsh
source "$ZDOTDIR"/.zshenv' > ~/.zshenv

echo '5. Adding some finishing touches...'
for setup in ~/.config/setup/*; do
    echo "Running $setup..."
    source "$setup"
done

echo 'Completed!'
