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
set bell-style none

# Tmux Wrapper for ssh so it displays hostname in title
settitle() {
  printf "\033k$1\033\\"
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

# Docker
#export DOCKER_HOST=tcp://localhost:2375
