#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
tools_dir=${HOME}/tools
source ${libdir}/lib.sh

topic 'UPDATE TERRAFORM AND TERRAGRUNT'

task 'Update tfenv'
if [ ! -e ${tools_dir}/tfenv ] ;then
  git clone --depth=1 https://github.com/tfutils/tfenv.git ${tools_dir}/tfenv
  export PATH=${tools_dir}/tfenv/bin:$PATH
else
  git -C ${tools_dir}/tfenv pull
  source ${HOME}/.bashrc
fi
tfenv install 1.2.9

task 'Update tgenv'
if [ ! -e ${tools_dir}/tgenv ] ;then
  git clone https://github.com/sigsegv13/tgenv.git ${tools_dir}/tgenv
  export PATH=${tools_dir}/tgenv/bin:$PATH
else
  git -C ${tools_dir}/tgenv pull
fi
tgenv install 0.48.7
