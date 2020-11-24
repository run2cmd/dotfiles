# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#=====================================
#         ENVIRONMENT SETTINGS
#=====================================

# Language
export LC_ALL=en_US.UTF-8
export LANG=$LC_ALL
#export LS_COLORS="$LS_COLORS:di=0,104"

# Append to history file instead of overwrite
shopt -s histappend
export HISTSIZE=10000
export HISTFILESIZE=2000
PROMPT_COMMAND='history -a'

# Ignore case for autocompletion
if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Do not put duplicates into history
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# disable ctrl+s freezing terminal
stty -ixon

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Editor options
export EDITOR='vi'
export VISUAL='vi'
export PAGER=less

# Setup path
export PATH=~/bin:$PATH

# Vagrant workaround
export VAGRANT_DETECTED_OS=cygwin

# Terminal settings
export TERM=xterm-256color
set bell-style none
#=====================================
#               SSH AGENT
#=====================================
#if [ ! -e ~/.ssh ] ;then
#  mkdir -p ~/.ssh
#  chmod 0700 ~/.ssh
#fi
## Setup SSH Agent
#SSH_ENV="${HOME}/.ssh/environment"
#function start_agent {
#  echo "Initialising new SSH agent..."
#  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
#  echo succeeded
#  chmod 600 "${SSH_ENV}"
#  . "${SSH_ENV}" > /dev/null
#  /usr/bin/ssh-add;
#}
#
#if [ -f "${SSH_ENV}" ]; then
#  . "${SSH_ENV}" > /dev/null
#  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent &> /dev/null || {
#    start_agent;
#  }
#else
#   start_agent;
#fi

#=====================================
#               VIM SETUP
#=====================================
#if [ ! -e ~/.vim/bundle/ide.vim ] ;then
#  mkdir -p ~/.vim/bundle
#  cd ~/.vim/bundle
#  git clone https://github.com/run2cmd/ide.vim.git
#fi
#if [ ! -e ~/.vim/backup ] ;then
#  mkdir -p ~/.vim/backup
#fi
#if [ ! -e ~/.vim/tmp ] ;then
#  mkdir -p ~/.vim/tmp
#fi

#=====================================
#               TMUX
#=====================================

#Wrapper for ssh so it displays hostname in title
settitle() {
  printf "\033k$1\033\\"
}
ssh() {
  settitle "$*"
  command ssh "$@"
  settitle "bash"
}

#=====================================
#               ALIASES
#=====================================
alias ls='ls --color'
alias grep='grep --color'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
source $HOME/.rvm/scripts/rvm

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/pbugala/.sdkman"
[[ -s "/home/pbugala/.sdkman/bin/sdkman-init.sh" ]] && source "/home/pbugala/.sdkman/bin/sdkman-init.sh"
