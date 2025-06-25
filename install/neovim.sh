#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh
toolsdir=${HOME}/tools

topic 'UPDATE NEOVIM'

url=https://github.com/neovim/neovim/releases/latest/download
image_file=nvim-linux-x86_64.appimage
appfile=${toolsdir}/nvim.appimage
git_sha="$(wget -qO- ${url}/nvim.appimage.sha256sum | cut -d' ' -f1)"
file_sha="$(sha256sum ${appfile} | cut -d' ' -f1)"
if [ ! -e ${appfile} ] || [ "${git_sha}" != "${file_sha}" ] ;then
  wget -q -O ${appfile} ${url}/${image_file}
  # shellcheck disable=SC2046
  [ $(wc -l ${appfile} | cut -d" " -f1) -eq 0 ] && echo "Failed to download ${url}/${image_file}" && exit 1
  chmod u+x ${appfile}
  ${appfile} --version
  # shellcheck source=../bashrc
  source ${HOME}/.bashrc
fi
ln -snf ${appfile} ${HOME}/bin/nvim

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
