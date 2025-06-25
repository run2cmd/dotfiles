#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh

topic 'UPDATE NODEJS'

# shellcheck source=~/.nvm/nvm.sh
source "${HOME}/.nvm/nvm.sh"

if [ ! -e ${HOME}/.nvm ] ; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  # shellcheck source=../bashrc
  source ${HOME}/.bashrc
fi

cd ~/ || exit 1

nvm install node
nvm install 18.20.4
nvm alias default node
nvm use node
npm install
npm install -g
npm update
npm link

task "Cleanup after update"
nvm cache clear
node_path=${HOME}/.nvm/versions/node
node_to_remove=$(ls --color=never $node_path | grep -Ev "$(node --version)")
for n in $node_to_remove ;do
  echo "Remove ${n}"
  rm -rf ${node_path:?}/${n}
done
