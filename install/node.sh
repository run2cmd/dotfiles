#!/bin/bash
#
# Install NodeJs and tools.
#
LIBDIR=$(dirnam "$(readlink -f $0)")
source ${LIBDIR}/lib.sh

topic 'UPDATE NODEJS'

source "${HOME}/.nvm/nvm.sh"

if [ ! -e ${HOME}/.nvm ] ; then
 curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi

nvm install node
nvm alias default node
nvm use node
npm install
npm update
npm link
