ZIM_HOME="${ZDOTDIR:-${HOME}}"/.zim

if [[ ! -e "${ZIM_HOME}"/zimfw.zsh ]]; then
  echo 'Downloading zimfw plugin manager...'

  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o "${ZIM_HOME}"/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p "${ZIM_HOME}" && wget -nv -O "${ZIM_HOME}"/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

if [[ ! "${ZIM_HOME}"/init.zsh -nt "${ZDOTDIR:-${HOME}}"/.zimrc ]]; then
  echo 'Installing zim modules...'
  source "${ZIM_HOME}"/zimfw.zsh init -q
fi

FZF_PREVIEW='sed -e "s/^ *[0-9]*  //; s/\\\\n/\n/g" <<< {} | (bat --plain --color=always --language=zsh || cat) 2>/dev/null'
FZF_PREVIEW_WINDOW=':wrap'

# Initialize modules.
source "${ZIM_HOME}"/init.zsh
