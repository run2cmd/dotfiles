# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Append to history file instead of overwrite
shopt -s histappend
export HISTSIZE=10000
export HISTFILESIZE=2000
PROMPT_COMMAND='history -a'

# Ignore case for autocompletion
bind "set completion-ignore-case on"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Do not put duplicates into history
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Editor options
export EDITOR='vi'
export VISUAL='vi'
export PAGER=less

# Setup path
export PATH=~/bin:$PATH

# Terminal settings
export TERM=xterm-256color

# Tmux Wrapper for ssh so it displays hostname in title
settitle() {
  printf "\033k%s\033\\" $1
}
ssh() {
  settitle "$*"
  command ssh "$@"
  settitle "bash"
}

# Aliases
alias ls='ls --color'
alias grep='grep --color'

## Setup local bin
export PATH="/usr/local/bin:$PATH"

# Workaround WSL 2 issues with not releasing memory
# See: https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643
alias drop_cache="sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""

# Easy switch dir for /code directory
alias cdc='cd $(fdfind --type directory --full-path --exact-depth 1 . /code | fzf)'

alias luamake=${HOME}/tools/lua-language-server/3rd/luamake/luamake
export PATH=$PATH:${HOME}/.pulumi/bin
export ANSIBLE_ROLES_PATH=/code/ansible-igt-puppet/roles:/code/ansible-igt-services/roles:/code/ansible-dew-common/roles

set -o vi

# Git nice PS
parse_git_branch() {
  if test -d .git ;then
    GBRANCH=$(git branch --show-current)
    GDESC=$(git describe --tags --always)
    echo " (${GBRANCH})(${GDESC})"
  fi
}
export PS1="[\e[34m\]\u@\h \[\e[32m\]\w\[\e[91m\]\$(parse_git_branch)\[\e[00m\]]$ "

# Load pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [ -e $PYENV_ROOT ] ;then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  [ -s "$NVM_DIR/bash_completion" ] && source $PYENV_ROOT/completions/pyenv.bash
fi

## Load nvm and nvm bash_completion
export NVM_DIR="$HOME/.nvm"
if [ -e $NVM_DIR ] ;then
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  export PATH=$HOME/node_modules/.bin:$PATH
fi

# Load RVM into a shell session *as a function*
export RVM_ROOT="$HOME/.rvm"
if [ -e $RVM_ROOT ] ;then
  export PATH="$PATH:$RVM_ROOT/bin"
  [ -s "$RVM_ROOT/scripts/rvm" ] && source "$RVM_ROOT/scripts/rvm"
fi

# Load sdkman
export SDKMAN_DIR="$HOME/.sdkman"
if [ -e $SDKMAN_DIR ] ; then
  [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"
  export GRADLE_OPTS=-Dorg.gradle.daemon=false
  export JAVA_OPTS='-Xms256m -Xmx2048m'
  export MAVEN_ARGS='-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true -Dmaven.resolver.transport=wagon'
fi

# Add golang to path
export PATH=$PATH:/home/pbugala/tools/go/main/go/bin

# Tgenv and tfenv setup
export PATH=$HOME/tools/tfenv/bin:$PATH
export PATH=$HOME/tools/tgenv/bin:$PATH

# SSH Agent
pgrep ssh-agent &>/dev/null || eval `keychain --eval --agents ssh id_rsa`

# Fix for IGT VPN
if ip addr | grep eth0 | grep -q 1500 ;then ~/bin/vpnfix ; fi
