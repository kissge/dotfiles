zstyle -d ':completion:*' format
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' switch-group '~' '`'

# Preview
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info $word'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview	'
  if [ ! -e ${realpath:-$word} ] || git ls-files --error-unmatch ${realpath:-$word} > /dev/null 2>&1; then
    git diff --no-ext-diff ${realpath:-$word} | diff-so-fancy
  else
    ([[ -f $realpath ]] && (bat --style=numbers --color=always $realpath || cat $realpath)) ||
      ([[ -d $realpath ]] && tree -CL 1 $realpath) ||
      echo $desc
  fi 2> /dev/null'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview	'case "$group" in
	"commit tag") git show $word | diff-so-fancy ;;
	*) git show $word | diff-so-fancy ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview	'case "$group" in
	"modified file") git diff --no-ext-diff $word | diff-so-fancy ;;
	"recent commit object name") git show --color=always $word ;;
	*) git log --color=always $word ;;
	esac'
zstyle ':fzf-tab:complete:man:*' fzf-preview 'man $word'
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  ([[ -f $realpath ]] && (bat --style=numbers --color=always $realpath || cat $realpath) 2> /dev/null) ||
    ([[ -d $realpath ]] && tree -CL 1 $realpath 2> /dev/null) ||
    echo $desc'
zstyle ':fzf-tab:complete:*:options' fzf-preview
zstyle ':fzf-tab:complete:*:options' fzf-flags '--no-preview'
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
zstyle ':fzf-tab:complete:*:argument-1' fzf-flags '--no-preview'

