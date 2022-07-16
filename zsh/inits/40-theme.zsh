source "$ZDOTDIR"/inits/theme/basic.zsh
source "$ZDOTDIR"/inits/theme/hostname.zsh
source "$ZDOTDIR"/inits/theme/timer.zsh

function __prompt() {
    local exitcode=$?

    echo

    __prompt_time
    __prompt_pwd_and_git
    __prompt_hostname
    __prompt_timer

    if ((exitcode != 0)); then
        __prompt_exitcode "$exitcode"
    fi

    echo

    # <foreground yellow>
    echo -n '%F{11}'
    # dollar sign
    echo -n '$ '
    # </foreground>
    echo -n '%f'
}

PROMPT='$(__prompt)'
