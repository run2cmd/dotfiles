#!/bin/bash
#
# Install Python
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh

topic 'UPDATE PYTHON'

export PYTHON_CONFIGURE_OPTS="--enable-shared"
PYTHON_VERSION=3.8.13
if [ ! -e ${HOME}/.pyenv ] ;then
 export PYENV_GIT_TAG=v${PYTHON_VERSION}
 curl https://pyenv.run | bash
 pyenv install ${PYTHON_VERSION}
 pyenv global ${PYTHON_VERSION}
fi

pyenv update
python -m pip install --upgrade pip
pip install -r ${HOME}/Pythonfile --upgrade
ansible-galaxy collection install community.general
