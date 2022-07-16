if (( ${+commands[code]} )); then
    export EDITOR='code --wait'
elif (( ${+commands[nano]} )); then
    export EDITOR=nano
fi
