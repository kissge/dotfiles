function __prompt_timer() {
    if ((__hook_timer_duration < 3)); then
        return
    fi

    # <background yellow>
    echo -n '%K{11}'
    # <foreground black>
    echo -n '%F{16}'
    # space
    echo -n ' '

    # last command's execution time
    local t=$__hook_timer_duration
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
