#!/bin/zsh

. ${HOME}/.sao/init

init_loader

ZSH_THEME=../../../../..$SAO_DIR/common/bullet-train-modified
plugins=(git history-substring-search pip zsh-autosuggestions)
BULLETTRAIN_DIR_EXTENDED=2
BULLETTRAIN_VIRTUALENV_PREFIX=🅿
oh-my-zsh

PATH=${HOME}/.gem/ruby/2.7.0/bin:$PATH
export EDITOR=nano
