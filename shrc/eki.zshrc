#!/bin/zsh

. ${HOME}/.sao/init

export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
eval "$(rbenv init -)"

init_loader

ZSH_THEME=philips
plugins=(git)
oh-my-zsh

if [ -n "$TMUX" -a "$TERM" = "screen" -a -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
    export TERM=xterm-256color
    source "${HOME}/.iterm2_shell_integration.zsh"
    local _HOSTNAME="$LC_ITERM_HOSTNAME"
    if [ -z "$_HOSTNAME" ]; then _HOSTNAME="$(hostname -f)"; fi
    iterm2_set_user_var hostname "$_HOSTNAME" # <- this didn't work...why?
    iterm2_print_user_vars() {
        iterm2_set_user_var hostname "$_HOSTNAME"
    }
fi
