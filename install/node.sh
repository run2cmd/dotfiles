#!/bin/bash
#
# Install NodeJs and tools.
#
libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh

topic 'UPDATE NODEJS'

# shellcheck disable=SC1091
source "${HOME}/.nvm/nvm.sh"

if [ ! -e ${HOME}/.nvm ] ; then
 curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi

nvm install node
nvm alias default node
nvm use node
npm install
npm install -g
npm update
npm link
