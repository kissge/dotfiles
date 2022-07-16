function readable_fg_color() {
    if (((0 <= $1 && $1 <= 6) || (\
        8 <= $1 && $1 <= 9) || (\
        16 <= $1 && $1 <= 37) || (\
        52 <= $1 && $1 <= 70) || (\
        88 <= $1 && $1 <= 105) || (\
        124 <= $1 && $1 <= 140) || (\
        160 <= $1 && $1 <= 171) || (\
        196 <= $1 && $1 <= 204) || (\
        232 <= $1 && $1 <= 246))); then
        echo 15 # white
    else
        echo 0 # black
    fi
}

__prompt_host_bg=$((0x$(uname -n | (md5sum || md5) | head -c2)))
__prompt_host_fg=$(readable_fg_color "$__prompt_host_bg")

function __prompt_hostname() {
    # <background $__prompt_host_bg>
    echo -n "%K{$__prompt_host_bg}"
    # <foreground $__prompt_host_fg>
    echo -n "%F{$__prompt_host_fg}"
    # space
    echo -n ' '
    # hostname (first part)
    echo -n '%m'
    # space
    echo -n ' '
    # </foreground>
    echo -n '%f'
    # </background>
    echo -n '%k'
}
