function __prompt_time() {
    # <background white>
    echo -n '%K{white}'
    # <foreground white># </foreground>
    echo -n '%F{white}#%f'
    # <foreground black>
    echo -n '%F{16}'
    # <bold>
    echo -n '%B'
    # HH:MM:SSTTT
    echo -n '%D{%T%Z}'
    # space
    echo -n ' '
    # </bold>
    echo -n '%b'
    # </foreground>
    echo -n '%f'
    # </background>
    echo -n '%k'
}

function __prompt_pwd_and_git() {
    # <background blue>
    echo -n '%K{blue}'
    # space
    echo -n ' '
    # <bold>
    echo -n '%B'
    # current directory (long)
    echo -n '%0~'
    # </bold>
    echo -n '%b'

    local branch

    if branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); then
        # <foreground lightblue>
        echo -n '%F{69}'
        # git branch
        echo -n ": %{$branch%}"
        # </foreground>
        echo -n '%f'
    fi

    # space
    echo -n ' '
    # </background>
    echo -n '%k'
}

function __prompt_exitcode() {
    # <background red>
    echo -n '%K{red}'
    # <foreground white>
    echo -n '%F{white}'
    # <bold>
    echo -n '%B'
    # space
    echo -n ' '
    # last command's exit code
    echo -n "$1"
    # space
    echo -n ' '
    # </bold>
    echo -n '%b'
    # </foreground>
    echo -n '%f'
    # </background>
    echo -n '%k'
}
