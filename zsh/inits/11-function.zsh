
if (( ${+commands[code]} )); then
  function code() {
    if [ $# -eq 0 ]; then
      command code .
    else
      command code "$@"
    fi
  }
fi
