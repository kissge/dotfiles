#!/bin/zsh

. ${HOME}/.sao/init

init_loader

if @exist rbenv; then
    export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
    eval "$(rbenv init -)"
fi

ZSH_THEME=philips
plugins=(git)
oh-my-zsh

if [ "$_ITERM" -a -n "$TMUX" -a "$TERM" = "screen" ]; then
    export TERM=xterm-256color
    local _HOSTNAME="$LC_ITERM_HOSTNAME"
    if [ -z "$_HOSTNAME" ]; then _HOSTNAME="$(hostname -f)"; fi
    iterm2_set_user_var hostname "$_HOSTNAME" # <- this didn't work...why?
    iterm2_print_user_vars() {
        iterm2_set_user_var hostname "$_HOSTNAME"
    }
fi
