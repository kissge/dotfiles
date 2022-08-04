zstyle -d ':completion:*' format
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' switch-group ',' '.'

# Preview
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info $word'
zstyle ':fzf-tab:complete:man:*' fzf-preview 'man $word'
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  ([[ -f $realpath ]] && (bat --style=numbers --color=always $realpath || cat $realpath)) ||
    ([[ -d $realpath ]] && tree -CL 1 $realpath) ||
    echo $desc'
zstyle ':fzf-tab:complete:*:options' fzf-preview
zstyle ':fzf-tab:complete:*:options' fzf-flags '--no-preview'
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
zstyle ':fzf-tab:complete:*:argument-1' fzf-flags '--no-preview'

