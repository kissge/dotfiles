#!/bin/bash

function md() {
    mkdir -p "$1" && builtin cd "$1" && pwd
}

function cd() {
    # Get last argument
    local LAST
    for LAST; do :; done

    if [ -f "$LAST" ]; then
        builtin cd "${@:1:$(($# - 1))}" "$(dirname -- "$LAST")"
    elif [ -d "$LAST" ]; then # redundant?
        builtin cd "$@"
    elif [ "$#" -ne 0 ] && which wslpath >/dev/null 2>&1; then
        builtin cd "$(wslpath "$@")"
    else
        local CDPATH="$__CDPATH"
        builtin cd "$@"
    fi
}

function @exist() {
    which "$1" >/dev/null 2>&1
}

function export-dotenv() {
    local dotenv=${1:-.env}

    if [ ! -f "$dotenv" ]; then
        echo "No such file: $dotenv"
        return 1
    fi

    local temp1=$(mktemp)
    local temp2=$(mktemp)

    env -i bash --noprofile --norc -c 'declare -p' >"${temp1}"
    env -i bash --noprofile --norc -c '. "'"${dotenv}"'" && declare -p' >"${temp2}"
    exports=$(diff --old-line-format="" --new-line-format="export %L" --unchanged-line-format="" "${temp1}" "${temp2}" |
        grep -v '^export \(BASH_EXECUTION_STRING\|PIPESTATUS\|_\)=')

    eval "${exports}"

    echo "Read ${dotenv} and exported the following:"
    echo "${exports}"
}

function upp() {
    command upp | less -RFX
}
