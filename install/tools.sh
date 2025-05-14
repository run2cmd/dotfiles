#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
tools_dir=${HOME}/tools
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

task "Update puppet editor services (LSP)"
dir_path=${tools_dir}/puppet-editor-services
[ ! -e ${dir_path} ] && git clone https://github.com/puppetlabs/puppet-editor-services.git ${dir_path}
if [ ! -e "${dir_path}/Gemfile.lock" ] || git -C ${dir_path} remote show origin | grep 'out of date' ;then
  cd ${dir_path}
  git reset --hard main
  git pull
  bundle install --gemfile=${dir_path}/Gemfile
  bundle exec rake -f ${dir_path}/Rakefile gem_revendor
  cd -
  ln -snf ${dir_path}/puppet-languageserver ~/bin/puppet-languageserver
fi
