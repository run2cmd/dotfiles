#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh
#shellcheck disable=SC2046
repodir=$(dirname $(dirname "$(readlink -f $0)"))

topic 'SETUP DOTFILES'

make_dirs=(
  "${HOME}/.config/nvim/undo"
  "${HOME}/.config/nvim/tmp"
  "${HOME}/.config/rubocop"
  "${HOME}/tools"
)
for mdir in "${make_dirs[@]}" ;do
  mkdir -p ${mdir}
done

declare -A make_links=(
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
  ["markdownlint.yaml"]="markdownlint.yaml"
  ["mdl_style.rb"]=".mdl_style.rb"
  ["shellcheckrc"]=".shellcheckrc"
  ["ctags.d"]=".ctags.d"
  ["gitattributes"]=".gitattributes"
  ["gitconfig"]=".gitconfig"
  ["irbrc"]=".irbrc"
  ["rvmrc"]=".rvmrc"
  ["puppet-lint.rc"]=".puppet-lint.rc"
  ["reek"]=".reek"
  ["screenrc"]=".screenrc"
  ["tmux.conf"]=".tmux.conf"
  ["vintrc.yaml"]=".vintrc.yaml"
  ["yamllint"]=".config/yamllint"
  ["Pythonfile"]="Pythonfile"
  ["package.json"]="package.json"
  ["Gemfile"]="Gemfile"
  ["Gemfile_2.7.3"]="Gemfile_2.7.3"
  ["Gemfile_2.4.10"]="Gemfile_2.4.10"
  ["Gemfile_2.0.0"]="Gemfile_2.0.0"
  ["Pkgfile"]="Pkgfile"
  ["rubocop.yml"]=".config/rubocop/config.yml"
  ["codenarc.properties"]=".codenarc.properties"
  ["gitexclude"]=".gitignore"
)
for mlink in "${!make_links[@]}" ;do
  ln -snf ${repodir}/${mlink} ${HOME}/${make_links["${mlink}"]}
done

if ! (grep -q 'dotfiles' ${HOME}/.bashrc) ;then
 echo '# Laod dotfiles setup' >> ${HOME}/.bashrc
 # shellcheck disable=SC2016
 echo 'source ${HOME}/dotfiles/bashrc' >> ${HOME}/.bashrc
fi

if [ ! -e ${HOME}/.bash_profile ] ;then
  echo '[ -s "$HOME/.profile" ] && source "$HOME/.profile"' > ${HOME}/.bash_profile
fi
