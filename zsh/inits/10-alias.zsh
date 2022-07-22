alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'

# "If the replacement text ends with a space, the next word in the shell input is always eligible for purposes of alias expansion."
# https://zsh.sourceforge.io/Doc/Release/Shell-Grammar.html#Aliasing
alias sudo='sudo '

alias curlj='curl -H "Content-type: application/json"'

alias history="fc -l -t '%FT%TZ'"

alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'
alias gd='git diff'

if (( ${+commands[ggrep]} )); then
  alias grep='ggrep --color=auto'
fi
