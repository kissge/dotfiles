# nvm: Node Version Manager
if [ -s /usr/local/opt/nvm/nvm.sh ]; then
  # Homebrew
  . /usr/local/opt/nvm/nvm.sh
  . /usr/local/opt/nvm/etc/bash_completion.d/nvm
elif [ -s /usr/share/nvm/init-nvm.sh ]; then
  . /usr/share/nvm/init-nvm.sh
fi
