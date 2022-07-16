# Make cd push the old directory to the directory stack.
setopt AUTO_PUSHD

# Allow comments starting with `#` in the interactive shell.
setopt INTERACTIVE_COMMENTS

# The prompt string is first subjected to parameter expansion, command substitution and arithmetic expansion.
setopt PROMPT_SUBST

# Modified from https://memo.sugyan.com/entry/20100712/1278869962
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars ' _-,./:;@(){}[]'
zstyle ':zle:*' word-style unspecified

# By default zsh removes whitespace after the completion when typing a certain character like ';'.
# Remove '|' and '&' from the list.
# https://zsh.sourceforge.io/Doc/Release/Parameters.html#index-ZLE_005fREMOVE_005fSUFFIX_005fCHARS
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;'

bindkey '^U' backward-kill-line

# Alt + Left/Right
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
