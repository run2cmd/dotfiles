#!/bin/bash
#
# Install Ruby
#
libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh

topic 'UPDATE RUBY'

default_ruby=3.2.2

task 'Update rvm'
if [ ! -e ${HOME}/.rvm ] ;then
  curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
  curl -sSL https://get.rvm.io | bash -s stable --version $default_ruby
fi

# shellcheck disable=SC1091
source "${HOME}/.rvm/scripts/rvm"

rvm get stable
rvm autolibs enable

# Older ruby versions requires old OpenSSL
# shellcheck disable=SC2154
if [ ! -e ${rvm_path}/usr/bin/openssl ] ;then
  rvm pkg install openssl
fi

# Add proper certificates for older OpenSSL
if [ ! -L "${rvm_path}/usr/ssl" ] ;then
  mv ${rvm_path}/usr/ssl ${rvm_path}/usr/ssl_orig
  ln -s /usr/lib/ssl ${rvm_path}/usr/ssl
fi

# shellcheck disable=SC1091
source "${HOME}/.rvm/scripts/rvm"

task 'Install rubies'
rvm install $default_ruby --default
rvm install 2.7.3 --with-openssl-dir=${rvm_path}/usr
rvm install 2.4.10 --with-openssl-dir=${rvm_path}/usr

# Install rubocop per ruby version for solargraph proper support
rvm use 2.7.3 && (which rubocop &>/dev/null|| gem install rubocop --version 0.79.0)
rvm use 2.4.10 && (which rubocop &>/dev/null || gem install rubocop --version 0.71.0)

task "Update default ruby"
rvm use $default_ruby
gem install bundle
bundle update
