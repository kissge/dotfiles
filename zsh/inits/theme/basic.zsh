function __prompt_time() {
    # <background white>
    echo -n '%K{white}'
    # <foreground white># </foreground>
    echo -n '%F{white}#%f'
    # <foreground black>
    echo -n '%F{16}'
    # HH:MM:SSTTT
    echo -n '%D{%T%Z}'
    # space
    echo -n ' '
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

    # current directory
    local git_root
    if git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
        # <bold>
        echo -n '%B'
        # current directory, down to git root
        echo -n "${git_root/#$HOME/~}"
        # </bold>
        echo -n '%b'
        # <foreground grey>
        echo -n '%F{223}'
        # current directory, rest of
        echo -n "${PWD##"$git_root"}"
        # </foreground>
        echo -n '%f'

        # <foreground lightblue>
        echo -n '%F{87}'
        # git branch
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || branch='n/a'
        echo -n ": %{$branch%}"
        # </foreground>
        echo -n '%f'
    else
        # not inside a git repo
        # <bold>
        echo -n '%B'
        # current directory
        echo -n '%0~'
        # </bold>
        echo -n '%b'
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
