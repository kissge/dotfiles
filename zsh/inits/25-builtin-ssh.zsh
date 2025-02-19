function refresh-ssh-env() {
  if [ -n "$TMUX" ]; then
    local vars=$(tmux show-environment | sed -nE '/=/s/(.+?)=(.*)/\1="\2"/p')
    eval export "$vars"
  elif [ $TERM_PROGRAM = vscode ]; then
    export SSH_AUTH_SOCK=$(ls -t /tmp/ssh-*/agent* | head -1)
  else
    echo "Unknown environment (Use in tmux or vscode)"
    return 1
  fi
}
