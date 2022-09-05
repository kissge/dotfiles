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

function generate_dark_bg_color() {
    perl -MPOSIX -e '$h = $ARGV[0] * 6 / 256; $i = floor($h); $f = $h - $i; $q = 5 - 4 * $f; $t = 1 + 4 * $f;
        $r = (5, $q, 1, 1, $t, 5)[$i] * 10; $g = ($t, 5, 5, $q, 1, 1)[$i] * 10; $b = (1, $t, $t, 5, 5, $q)[$i] * 10;
        # iTerm2
        printf("\033]1337;SetColors=bg=%02x%02x%02x\033\\", $r, $g, $b);
        # Konsole
        printf("\033]11;#%02x%02x%02x\007", $r, $g, $b);' "$1"
}

if (( ${+SSH_CONNECTION} )); then
    __terminal_host_bg=$(generate_dark_bg_color "$__prompt_host_bg")
else
    __terminal_host_bg='\033]1337;SetColors=bg=000000\033\\\033]111\007'
fi

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

    # Set terminal background color
    echo -n "$__terminal_host_bg"
}
