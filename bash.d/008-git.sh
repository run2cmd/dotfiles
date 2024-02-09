parse_git_branch() {
  if test -d .git ;then
    GBRANCH=$(git branch --show-current)
    GDESC=$(git describe --tags --always)
    echo " (${GBRANCH})(${GDESC})"
  fi
}
export PS1="[\e[34m\]\u@\h \[\e[32m\]\w\[\e[91m\]\$(parse_git_branch)\[\e[00m\]]$ "
