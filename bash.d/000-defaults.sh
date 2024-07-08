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
alias drop_cache="sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""

# Easy switch dir for /code directory
alias cdc='cd $(fdfind --type directory --full-path --exact-depth 1 . /code | fzf)'

alias luamake=${HOME}/tools/lua-language-server/3rd/luamake/luamake
export PATH=$PATH:${HOME}/.pulumi/bin
export ANSIBLE_ROLES_PATH=/code/a32-tools/ansible-igt-puppet/roles:/code/a32-tools/ansible-igt-services/roles:/code/dew/ansible-dew-common/roles

set -o vi

# Fix for IGT VPN
if ip addr | grep eth0 | grep -q 1500 ;then ~/bin/vpnfix ; fi

# SSH Agent
pgrep ssh-agent &>/dev/null || eval `keychain --eval --agents ssh id_rsa`
