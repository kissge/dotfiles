function refresh-tmux-env() {
  if [ -z "$TMUX" ]; then
    echo "Not in a tmux session"
    return 1
  fi

  local vars=$(tmux show-environment | sed -nE '/=/s/(.+?)=(.*)/\1="\2"/p')
  echo $vars
  eval export $vars
}
