#!/bin/bash
#
# Install NeoVim
#
libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh
toolsdir=${HOME}/tools

topic 'UPDATE NEOVIM'

appfile=${toolsdir}/nvim.appimage
appsha=/tmp/nvim.appimage.sha256sum
wget -q -O ${appsha} https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage.sha256sum
if [ ! -e ${appfile} ] || [ "$(cut -d " " -f1 < ${appsha})" != "$(sha256sum ${appfile} |cut -d " " -f1)" ] ;then
  wget -q -O ${appfile} https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod u+x ${appfile}
  ln -snf ${appfile} ~/bin/nvim
  ~/bin/nvim --version
fi

packerpath=~/.local/share/nvim/site/pack/packer/start
if [ ! -e ${packerpath}/packer.nvim ] ;then
 mkdir -p ${packerpath}
 git clone --depth 1 https://github.com/wbthomason/packer.nvim ${packerpath}/packer.nvim
fi

task "Update Neovim plugins"
timestamp_file=~/.local/share/nvim/plugins_timestamp
if ! test -f ${timestamp_file} ;then date +%Y-%m-%d > ${timestamp_file} ;fi
last_update=$(cat ${timestamp_file})
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
for i in $(fdfind --type d --exact-depth 2 . ~/.local/share/nvim/site/pack/packer) ;do
  echo "-> Update $(basename ${i})"
  git --git-dir ${i}/.git log --oneline --since="${last_update}"
done
date +%Y-%m-%d > ${timestamp_file}

task "Update Neovim treesitter"
nvim --headless -c 'TSUpdateSync | quitall'
echo ""
