echo 'Setting login shell...'
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

mkdir -pv ~/git
