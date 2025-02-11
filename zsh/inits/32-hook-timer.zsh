function __hook_timer_preexec() {
    __hook_timer_command="$2"
    __hook_timer_start=$(date +%s)
}

function __hook_timer_precmd() {
    if [ -n "$__hook_timer_start" ]; then
        __hook_timer_duration=$(($(date +%s) - __hook_timer_start))
        __hook_timer_start=

        if ((__hook_timer_duration > 300)); then
            __hook_timer_report="\`$__hook_timer_command\` completed in $__hook_timer_duration seconds"
        else
            __hook_timer_report=
        fi
    fi
}

TMOUT=60

function TRAPALRM() {
    # $TMOUT seconds elapsed since the prompt was displayed
    if [ -n "$__hook_timer_report" ]; then
        line-me <<< "$__hook_timer_report" > /dev/null 2>&1
        __hook_timer_report=
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook -Uz preexec __hook_timer_preexec
add-zsh-hook -Uz precmd __hook_timer_precmd
