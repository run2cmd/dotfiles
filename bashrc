# shellcheck disable=SC1091

# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Terminal settings
export TERM=xterm-256color

# Append to history file instead of overwrite
shopt -s histappend
shopt -s cmdhist
export HISTSIZE=10000
export HISTFILESIZE=2000
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=erasedups:ignoreboth
PROMPT_COMMAND='history -a'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Better TAB completion
bind "set completion-ignore-case on"
bind 'set show-all-if-ambiguous on'
bind "set completion-map-case on"

# Enable history expansion with space
bind Space:magic-space

# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

# Editor options
export EDITOR='vi'
export VISUAL='vi'
export PAGER=less
set -o vi

# Setup path
export PATH="/usr/local/bin:$PATH"
export PATH=~/bin:$PATH

# Git nice PS
# shellcheck disable=SC2025
export PS1="[\e[34m\]\u@\h \[\e[32m\]\w\[\e[91m\]\$(__git_ps1)\[\e[00m\]]\n$ "

# SSH Agent
eval "$(keychain -q --eval --agents ssh)"
ssh-add -l &>/dev/null || ssh-add ~/.ssh/id_rsa

# Add pulumi
export PATH=$PATH:${HOME}/.pulumi/bin

# Load pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [ -e "${PYENV_ROOT}" ] ;then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  source "$PYENV_ROOT/completions/pyenv.bash"
fi

## Load nvm and nvm bash_completion
export NVM_DIR="$HOME/.nvm"
if [ -e "${NVM_DIR}" ] ;then
  source "$NVM_DIR/nvm.sh"
  source "$NVM_DIR/bash_completion"
  export PATH=$HOME/node_modules/.bin:$PATH
fi

# Load RVM into a shell session *as a function*
export RVM_ROOT="$HOME/.rvm"
if [ -e "${RVM_ROOT}" ] ;then
  export PATH="$PATH:$RVM_ROOT/bin"
  source "$RVM_ROOT/scripts/rvm"
fi

# Load sdkman
export SDKMAN_DIR="$HOME/.sdkman"
if [ -e "${SDKMAN_DIR}" ] ; then
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  export GRADLE_OPTS=-Dorg.gradle.daemon=false
  export JAVA_OPTS='-Xms256m -Xmx2048m'
  export MAVEN_ARGS='-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true -Dmaven.resolver.transport=wagon'
fi

# Tgenv and tfenv setup
export PATH=$HOME/tools/tfenv/bin:$PATH
export PATH=$HOME/tools/tgenv/bin:$PATH

# Go setup
export PATH=$HOME/go/bin:$PATH

# Own completion
if [ -e "${HOME}/bash_completion.d" ] ;then
  source "${HOME}/.bash_completion.d/bash_completion"
  source "${HOME}/.bash_completion.d/gita_completion"
fi

# Aliases
alias ls='ls --color'
alias grep='grep --color'
alias cdc='cd $(fdfind --type directory --full-path --exact-depth 1 . /code | fzf)'
alias hst='history | fzf'

# Workaround WSL 2 issues with not releasing memory
# See: https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643
alias drop_cache="sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""

# Tmux Wrapper for ssh so it displays hostname in title
ssh() {
  settitle "$*"
  command ssh "$@"
  printf "\033k%s\033\\" "bash"
}

# Open 1st tmux session in dotfiles
tmux() {
  if [ $# -eq 0 ]; then
    command tmux new-session -A -s dotfiles -c /code/dotfiles
  else
    command tmux "$@"
  fi
}

