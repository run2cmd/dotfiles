#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
tools_dir=${HOME}/tools
source ${libdir}/lib.sh
# shellcheck source=../bashrc
source ${HOME}/.bashrc

topic 'UPDATE RUBY'

default_ruby=3.2.2
additional_rubies='2.7.3 2.4.10'

task 'Update rvm'
if [ ! -e ${HOME}/.rvm ] ;then
  gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  curl -sSL https://get.rvm.io | bash -s stable
fi

# shellcheck source=../../.rvm/scripts/rvm
source "${HOME}/.rvm/scripts/rvm"

rvm get stable
rvm autolibs enable

# shellcheck disable=SC2154
if [ ! -e ${rvm_path}/usr/bin/openssl ] ;then
  rvm pkg install openssl
fi

if [ ! -L "${rvm_path}/usr/ssl" ] ;then
  sudo mv ${rvm_path}/usr/ssl ${rvm_path}/usr/ssl_orig
  sudo ln -s /usr/lib/ssl ${rvm_path}/usr/ssl
fi

# shellcheck disable=SC1091
source "${HOME}/.rvm/scripts/rvm"

task 'Install rubies'
rvm install $default_ruby --default

for rb in $additional_rubies ;do
  rvm install ${rb} --with-openssl-dir=${rvm_path}/usr --autolibs=disable
  rvm use ${rb}
  BUNDLE_GEMFILE=Gemfile_${rb} gem install bundle
  BUNDLE_GEMFILE=Gemfile_${rb} bundle install
done

task "Update default ruby"
rvm use $default_ruby
gem install bundle
gem update --system
bundle update

task "Cleanup after update"
rvm cleanup all
rubies_path=${HOME}/.rvm/rubies
rubies_to_remove=$(ls --color=never $rubies_path | grep -Ev "${default_ruby}|${additional_rubies// /|}|default")
for rb in $rubies_to_remove ;do
  echo "Remove ${rb}"
  rm -rf ${rubies_path:?}/${rb}
done

task "Update puppet editor services (LSP)"
dir_path=${tools_dir}/puppet-editor-services
[ ! -e ${dir_path} ] && git clone https://github.com/puppetlabs/puppet-editor-services.git ${dir_path}
if [ ! -e "${dir_path}/Gemfile.lock" ] || git -C ${dir_path} remote show origin | grep 'out of date' ;then
  cd ${dir_path} || exit 1
  git reset --hard main
  git pull
  bundle install --gemfile=${dir_path}/Gemfile
  bundle exec rake -f ${dir_path}/Rakefile gem_revendor
  cd - || exit 1
  ln -snf ${dir_path}/puppet-languageserver ~/bin/puppet-languageserver
fi
