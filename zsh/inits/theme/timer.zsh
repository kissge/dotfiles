function __prompt_timer_preexec() {
    __prompt_timer_start=$(date +%s)
}

function __prompt_timer_precmd() {
    if [ -n "$__prompt_timer_start" ]; then
        __prompt_timer_duration=$(($(date +%s) - __prompt_timer_start))
        __prompt_timer_start=

        if ((__prompt_timer_duration > 300)); then
            line-me <<<"Command completed in $__prompt_timer_duration seconds" >/dev/null 2>&1
        fi
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook -Uz preexec __prompt_timer_preexec
add-zsh-hook -Uz precmd __prompt_timer_precmd

function __prompt_timer() {
    if ((__prompt_timer_duration < 3)); then
        return
    fi

    # <background yellow>
    echo -n '%K{11}'
    # <foreground black>
    echo -n '%F{16}'
    # space
    echo -n ' '

    # last command's execution time
    local t=$__prompt_timer_duration
    if ((t > 60)); then
        if ((t > 60 * 60)); then
            if ((t > 60 * 60 * 24)); then
                echo -n "$((t / 60 / 60 / 24))d"
                ((t %= 60 * 60 * 24))
            fi
            echo -n "$((t / 60 / 60))h"
            ((t %= 60 * 60))
        fi
        echo -n "$((t / 60))m"
        ((t %= 60))
    fi
    echo -n "$t"s

    # space
    echo -n ' '
    # </foreground>
    echo -n '%f'
    # </background>
    echo -n '%k'
}
