#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh

topic 'UPDATE DEVELOPMENT TOOLS'

if [ ! -e /home/linuxbrew ] ;then
  task 'Install Homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

task 'Update brew packages'

brew update

to_install=''
pkglist="$(brew list)"
while read -r line ;do
  if ! (echo "${pkglist}" | grep -q "${line}") ;then
    to_install="${to_install} ${line}"
  fi
done < ${HOME}/Brewfile

if [ "${to_install}" != '' ] ;then
  brew install ${to_install}
fi

brew upgrade
brew cleanup
