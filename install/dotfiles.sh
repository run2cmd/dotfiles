#!/bin/bash
#
# Setup dotfiles
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh
REPODIR=$(dirname $(dirname "$(readlink -f $0)"))

topic 'SETUP DOTFILES'

MAKE_DIRS=(
  "${HOME}/.config/nvim/undo"
  "${HOME}/.config/nvim/tmp"
  "${HOME}/tools"
)
for mdir in "${MAKE_DIRS[@]}" ;do
  mkdir -p ${mdir}
done

declare -A MAKE_LINKS=(
  ["bash.d"]=".bash.d"
  ["inputrc"]=".inputrc"
  ["bin"]="bin"
  ["nvim/init.lua"]=".config/nvim/init.lua"
  ["nvim/syntax"]=".config/nvim/syntax"
  ["nvim/minisnip"]=".config/nvim/minisnip"
  ["nvim/scripts"]=".config/nvim/scripts"
  ["nvim/spell"]=".config/nvim/spell"
  ["nvim/lua"]=".config/nvim/lua"
  ["nvim/after"]=".config/nvim/after"
  ["mdlrc"]=".mdlrc"
  ["mdl_style.rb"]=".mdl_style.rb"
  ["shellcheckrc"]=".shellcheckrc"
  ["ctags.d"]=".ctags.d"
  ["gitattributes"]=".gitattributes"
  ["gitconfig"]=".gitconfig"
  ["irbrc"]=".irbrc"
  ["rvmrc"]=".rvmrc"
  ["puppet-lint.rc"]=".puppet-lint.rc"
  ["reek"]=".reek"
  ["rubocop.yaml"]=".rubocop.yaml"
  ["screenrc"]=".screenrc"
  ["tmux.conf"]=".tmux.conf"
  ["vintrc.yaml"]=".vintrc.yaml"
  ["codenarc"]=".codenarc"
  ["yamllint"]=".yamllint"
  ["pylintrc"]=".pylintrc"
  ["Pythonfile"]="Pythonfile"
  ["package.json"]="package.json"
  ["Gemfile"]="Gemfile"
  ["Rpmfile"]="Rpmfile"
)
for mlink in "${!MAKE_LINKS[@]}" ;do
  ln -snf ${REPODIR}/${mlink} ${HOME}/${MAKE_LINKS["${mlink}"]}
done

if ! (grep -q '\.bash\.d' ${HOME}/.profile) ;then
 echo '# Laod custom dotfiles' >> ${HOME}/.profile
 echo 'for i in ${HOME}/bash.d/* ;do source ${i} ;done' >> ${HOME}/.profile
fi
