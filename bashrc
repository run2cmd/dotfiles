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
set -o vi

# Setup path
export PATH="/usr/local/bin:$PATH"
export PATH=~/bin:$PATH

# Terminal settings
export TERM=xterm-256color

# Own completion
source ${HOME}/.bash_completion

# SSH Agent
if ! ssh-add -l &> /dev/null ;then
  pgrep ssh-add &> /dev/null && killall -9 ssh-add
  pgrep ssh-agent &> /dev/null && killall -9 ssh-agent
  eval `keychain -q --eval --agents ssh id_rsa`
fi

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
alias cdc='cd $(fdfind --type directory --full-path --exact-depth 1 . /code | fzf)'
alias luamake=${HOME}/tools/lua-language-server/3rd/luamake/luamake

# Workaround WSL 2 issues with not releasing memory
# See: https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643
alias drop_cache="sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""

# Add brew to path
[ -e /home/linuxbrew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Add pulumi
export PATH=$PATH:${HOME}/.pulumi/bin

# Add ansible roles
export ANSIBLE_ROLES_PATH=/code/ansible-igt-puppet/roles:/code/ansible-igt-services/roles:/code/ansible-dew-common/roles

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
  source $PYENV_ROOT/completions/pyenv.bash
fi

## Load nvm and nvm bash_completion
export NVM_DIR="$HOME/.nvm"
if [ -e $NVM_DIR ] ;then
  source "$NVM_DIR/nvm.sh"
  source "$NVM_DIR/bash_completion"
  export PATH=$HOME/node_modules/.bin:$PATH
fi

# Load RVM into a shell session *as a function*
export RVM_ROOT="$HOME/.rvm"
if [ -e $RVM_ROOT ] ;then
  export PATH="$PATH:$RVM_ROOT/bin"
  source "$RVM_ROOT/scripts/rvm"
fi

# Load sdkman
export SDKMAN_DIR="$HOME/.sdkman"
if [ -e $SDKMAN_DIR ] ; then
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  export GRADLE_OPTS=-Dorg.gradle.daemon=false
  export JAVA_OPTS='-Xms256m -Xmx2048m'
  export MAVEN_ARGS='-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true -Dmaven.resolver.transport=wagon'
fi

# Add golang to path
export PATH=$PATH:/home/pbugala/tools/go/main/go/bin

# Tgenv and tfenv setup
export PATH=$HOME/tools/tfenv/bin:$PATH
export PATH=$HOME/tools/tgenv/bin:$PATH

# Kubernetes completion
type kubectl &> /dev/null && source <(kubectl completion bash)

# WSL GUI fix
test -h /tmp/.X11-unix || (sudo rm -rf /tmp/.X11-unix && ln -s /mnt/wslg/.X11-unix /tmp/.X11-unix)
test /run/user/1000/wayland-0 || ln -s /mnt/wslg/runtime-dir/wayland-0 /run/user/1000/wayland-0
