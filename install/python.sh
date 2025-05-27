#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh

topic 'UPDATE PYTHON'

pyver=3.11.4

export PYTHON_CONFIGURE_OPTS="--enable-shared"

if [ ! -e ${HOME}/.pyenv ] ;then
  export PYENV_GIT_TAG=v${pyver}
  curl https://pyenv.run | bash
fi

pyenv update
pyenv install -s ${pyver}
pyenv install -s 3.8.17
pyenv global ${pyver}
cd ~/.pyenv && src/configure && make -C src

python -m pip install --upgrade pip
pip install -r ${HOME}/Pythonfile --upgrade
ansible-galaxy collection install community.general

wget -q -O ${HOME}/.bash_completion.d/gita_completion https://github.com/nosarthur/gita/blob/master/.gita-completion.bash

task "Cleanup after update"
pip cache purge
