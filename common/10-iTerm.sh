if [ -z "$EMACS" ]; then
    # Show cwd in the title bar
    export PROMPT_COMMAND='echo -ne "\033];${PWD/#$HOME/~}\007"; '"$PROMPT_COMMAND"

    test "$__BASH" -a -e "${HOME}/.iterm2_shell_integration.bash" && . "${HOME}/.iterm2_shell_integration.bash"
    test "$__ZSH" -a -e "${HOME}/.iterm2_shell_integration.zsh" && . "${HOME}/.iterm2_shell_integration.zsh"

    if [ $ITERM_SHELL_INTEGRATION_INSTALLED ]; then
        function ssh() {
            # find first argument that DOESN'T start with a hyphen
            local host=""
            for arg; do
                if [ "$arg" = "Batchmode yes" ]; then # scp completion (bash-completion)
                    command ssh "$@"
                    return $?
                fi
                if [[ "$arg" != -* ]]; then
                    host=$arg
                    break
                fi
            done

            iterm2_set_user_var hostname "$host"

            export LC_ITERM_HOSTNAME="$host"
            command ssh "$@"
        }

        function iterm2_print_user_vars() {
            iterm2_set_user_var hostname "${HOST:-local}"
        }
    fi
fi
