#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh

topic 'UPDATE DEVELOPMENT TOOLS'

[ ! -e ${HOME}/.bash_completions/ir.sh ] && ir --install-completion bash

task 'Login to github'
gh auth status | grep "Logged in to github" || gh auth refresh -s read:project
ir config --token "$(gh auth token)"

while read -r line ;do
  type ${line/*\//} &> /dev/null || ir get https://github.com/${line} -y
done < ${HOME}/ToolsList

ir upgrade

export HELM_INSTALL_DIR=${HOME}/bin
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

[ -e ${HOME}/tools/lua-language-server ] && lua_ver="$(lua-language-server --version)" || lua_ver='none'
lua_tag="$(gh repo view LuaLS/lua-language-server --json latestRelease -q .latestRelease.name)"
if [ "${lua_ver}" != "${lua_tag}" ] ;then
  lua_path=${HOME}/tools/lua-language-server
  lua_bin=${lua_path}/bin/lua-language-server
  mkdir -p ${HOME}/tools/lua-language-server
  wget -O /tmp/lua-ls.tar.gz https://github.com/LuaLS/lua-language-server/releases/download/${lua_tag}/lua-language-server-${lua_tag}-linux-x64.tar.gz
  tar -xf /tmp/lua-ls.tar.gz -C ${lua_path}
  chmod +x ${lua_bin}
  ln -snf ${lua_bin} ${HOME}/bin/lua-language-server
else
  echo "lua-language-server already at latest version ${lua_ver}"
fi

type az &>/dev/null || curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
