# shellcheck shell=bash

bindkey "^U" backward-kill-line
setopt NO_NOMATCH
# shellcheck disable=SC2034
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'
