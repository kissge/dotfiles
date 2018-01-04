#!/bin/bash

. ${HOME}/.sao/init

@ ${SAO_DIR}/common/ubuntu.default.bash || return

# Alt + Left, Alt + Right
bind '"\e[1;3D": backward-word'
bind '"\e[1;3C": forward-word'

init_loader

export PATH="${HOME}/.composer/vendor/bin:${PATH}"
