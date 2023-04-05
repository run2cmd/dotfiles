#!/bin/bash
#
# Install NeoVim
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh
TOOLSDIR=${HOME}/tools

topic 'UPDATE NEOVIM'

NVIM_PKG=/tmp/nvim-linux64.deb
NVIM_SHA=/tmp/nvim-linux64.deb.sha256sum
wget -q -O ${NVIM_SHA} https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb.sha256sum
if [ ! -e ${NVIM_PKG} ] || [ "$(cut -d " " -f1 < /tmp/nvim-linux64.deb.sha256sum)" != "$(sha256sum ${NVIM_PKG} |cut -d " " -f1)" ] ;then
 wget -q -O ${NVIM_PKG} https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb
 sudo dpkg -i ${NVIM_PKG}
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
  git --git-dir ${i}/.git log --oneline @{0}..origin --since="${PLUGINS_LAST_UPDATE}"
done
date +%Y-%m-%d > ${PLUGINS_TIMESTAMP_FILE}

task "Puppet Treesitter setup"
PUPPET_TS_DIR=${TOOLSDIR}/tree-sitter-puppet
PUPPET_Q_DIR=${HOME}/.local/share/nvim/site/pack/packer/start/nvim-treesitter/queries/puppet
if [ ! -e $PUPPET_TS_DIR ] ;then git clone https://github.com/neovim-puppet/tree-sitter-puppet.git ${PUPPET_TS_DIR} ;fi
git -C ${PUPPET_TS_DIR} pull
if [ ! -e $PUPPET_Q_DIR ] ;then mkdir -p $PUPPET_Q_DIR ;fi
cp ${PUPPET_TS_DIR}/queries/* ${PUPPET_Q_DIR}/

task "Update Neovim treesitter"
nvim --headless -c 'TSUpdate | quitall'

