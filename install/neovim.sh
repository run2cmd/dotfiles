#!/bin/bash
#
# Install NeoVim
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh
TOOLSDIR=${HOME}/tools

topic 'UPDATE NEOVIM'

NVIM_APP=${TOOLSDIR}/nvim.appimage
NVIM_SHA=/tmp/nvim.appimage.sha256sum
wget -q -O ${NVIM_SHA} https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage.sha256sum
if [ ! -e ${NVIM_APP} ] || [ "$(cut -d " " -f1 < ${NVIM_SHA})" != "$(sha256sum ${NVIM_APP} |cut -d " " -f1)" ] ;then
  wget -q -O ${NVIM_APP} https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod u+x ${NVIM_APP}
  ln -snf ${NVIM_APP} ~/bin/nvim
  ~/bin/nvim --version
fi

PACKERPATH=~/.local/share/nvim/site/pack/packer/start
if [ ! -e ${PACKERPATH}/packer.nvim ] ;then
 mkdir -p ${PACKERPATH}
 git clone --depth 1 https://github.com/wbthomason/packer.nvim ${PACKERPATH}/packer.nvim
fi

task "Update Neovim plugins"
PLUGINS_TIMESTAMP_FILE=~/.local/share/nvim/plugins_timestamp
if ! test -f ${PLUGINS_TIMESTAMP_FILE} ;then date +%Y-%m-%d > ${PLUGINS_TIMESTAMP_FILE} ;fi
PLUGINS_LAST_UPDATE=$(cat ${PLUGINS_TIMESTAMP_FILE})
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
for i in $(fdfind --type d --exact-depth 2 . ~/.local/share/nvim/site/pack/packer) ;do
  echo "-> Update $(basename ${i})"
  git --git-dir ${i}/.git log --oneline @\{0\}..origin --since="${PLUGINS_LAST_UPDATE}"
done
date +%Y-%m-%d > ${PLUGINS_TIMESTAMP_FILE}

task "Update Mason registry"
nvim --headless -c "MasonUpdate" -c qall
echo ""

task "Update tools"
nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'
echo ""

task "Update Neovim treesitter"
nvim --headless -c 'TSUpdateSync | quitall'
echo ""
