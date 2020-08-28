#!/bin/zsh

. ${HOME}/.sao/init

function readable_fg_color() {
  if (( (0 <= $1 && $1 <= 6) || \
        (8 <= $1 && $1 <= 9) || \
        (16 <= $1 && $1 <= 37) || \
        (52 <= $1 && $1 <= 70) || \
        (88 <= $1 && $1 <= 105) || \
        (124 <= $1 && $1 <= 140) || \
        (160 <= $1 && $1 <= 171) || \
        (196 <= $1 && $1 <= 204) || \
        (232 <= $1 && $1 <= 246) )); then
    echo 15 # white
  else
    echo 0 # black
  fi
}

init_loader

ZSH_THEME=../../../../..$SAO_DIR/common/bullet-train-modified
plugins=(git history-substring-search pip zsh-autosuggestions)
BULLETTRAIN_CONTEXT_BG=$(( 0x$(md5sum <<< "$HOST" | head -c2) ))
BULLETTRAIN_CONTEXT_FG=$(readable_fg_color "$BULLETTRAIN_CONTEXT_BG")
BULLETTRAIN_DIR_EXTENDED=2
BULLETTRAIN_VIRTUALENV_PREFIX=🅿
oh-my-zsh

PATH=${HOME}/.gem/ruby/2.7.0/bin:$PATH
export EDITOR=nano
