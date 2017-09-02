$SAO_DIR/common/isiterm2 && _ITERM=1 || _ITERM=

if [ "$_ITERM" -a -z "$EMACS" ]; then
    # Show cwd in the title bar
    export PROMPT_COMMAND='echo -ne "\033];${PWD/#$HOME/~}\007"; '"$PROMPT_COMMAND"

    @bash "${HOME}/.iterm2_shell_integration.bash"
    @zsh "${HOME}/.iterm2_shell_integration.zsh"

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
