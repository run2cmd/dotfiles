#!/bin/bash
#
# Install Python
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh

topic 'UPDATE PYTHON'

PYTHON_VERSION=3.8.17

export PYTHON_CONFIGURE_OPTS="--enable-shared"

if [ ! -e ${HOME}/.pyenv ] ;then
  export PYENV_GIT_TAG=v${PYTHON_VERSION}
  curl https://pyenv.run | bash
fi

pyenv update
pyenv install -s ${PYTHON_VERSION}
pyenv global ${PYTHON_VERSION}

python -m pip install --upgrade pip
pip install -r ${HOME}/Pythonfile --upgrade
ansible-galaxy collection install community.general
