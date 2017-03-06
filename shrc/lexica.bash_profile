#!/bin/bash

. ${HOME}/.sao/init

GIT_PROMPT_THEME=Default
@ "$(brew --prefix)/etc/bash_completion"
@ /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
@ "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"

export PATH="$HOME/.composer/vendor/bin:/usr/local/sbin:$PATH"
export NODE_PATH=/usr/local/lib/node_modules
export ANDROID_HOME=/usr/local/opt/android-sdk
export JAVA_HOME=/Library/Java/Home

init_loader
