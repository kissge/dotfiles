#!/bin/bash

. ${HOME}/.sao/init

@ ${SAO_DIR}/common/ubuntu.default.bash

# Alt + Left, Alt + Right
bind '"\e[1;3D": backward-word'
bind '"\e[1;3C": forward-word'

init_loader
