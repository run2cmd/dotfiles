#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh
toolsdir=${HOME}/tools

topic 'UPDATE NEOVIM'

appfile=${toolsdir}/nvim.appimage
sha_match="$(match_sha256sum https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage.sha256sum ${appfile})"
if [ ! -e ${appfile} ] || [ ${sha_match} == 'no-match' ] ;then
  wget -q -O ${appfile} https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod u+x ${appfile}
  ln -snf ${appfile} ~/bin/nvim
  ~/bin/nvim --version
fi

pm_path="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
if [ ! -e ${pm_path} ] ;then
  git clone --depth=1 https://github.com/savq/paq-nvim.git ${pm_path}
fi

task "Update Neovim plugins"
timestamp_file=~/.local/share/nvim/plugins_timestamp
if ! test -f ${timestamp_file} ;then date +%Y-%m-%d > ${timestamp_file} ;fi
last_update=$(cat ${timestamp_file})
nvim --headless -c 'autocmd User PaqDoneSync quitall' -c 'PaqSync'
for i in $(fdfind --type d --exact-depth 2 . ~/.local/share/nvim/site/pack/paqs) ;do
  echo "-> Update $(basename ${i})"
  git --git-dir ${i}/.git log --oneline --since="${last_update}"
done
date +%Y-%m-%d > ${timestamp_file}

task "Update Neovim treesitter"
nvim --headless -c 'TSUpdateSync | quitall'
echo ""
