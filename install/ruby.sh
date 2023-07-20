#!/bin/bash
#
# Install Ruby
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh

topic 'UPDATE RUBY'

DEFAULT_RUBY=3.2.2

task 'Update rvm'
if [ ! -e ${HOME}/.rvm ] ;then
  curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
  curl -sSL https://get.rvm.io | bash -s stable --version $DEFAULT_RUBY
fi

rvm get stable
rvm autolibs enable

# Older ruby versions requires old OpenSSL
if [ ! -e ${rvm_path}/usr/bin/openssl ] ;then
  rvm pkg install openssl
fi

source "${HOME}/.rvm/scripts/rvm"

task 'Install rubies'
rvm install $DEFAULT_RUBY --default
rvm install 2.7.3 --with-openssl-dir=$HOME/.rvm/usr
rvm install 2.4.10 --with-openssl-dir=$HOME/.rvm/usr

# Install rubocop per ruby version for solargraph proper support
rvm use 2.7.3 && (which rubocop &>/dev/null|| gem install rubocop --version 1.54.1)
rvm use 2.4.10 && (which rubocop &>/dev/null || gem install rubocop --version 0.93.1)

task "Update default ruby"
rvm use $DEFAULT_RUBY
gem install bundle
bundle update
