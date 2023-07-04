#!/bin/bash
#
# Install Ruby
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh

topic 'UPDATE RUBY'

RUBY_VERSION=3.2.2

if [ ! -e ${HOME}/.rvm ] ;then
  curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
  curl -sSL https://get.rvm.io | bash -s stable --version $RUBY_VERSION
  source '/home/pbugala/.rvm/scripts/rvm'
fi

rvm get stable
rvm autolibs enable

# Older ruby versions requires old OpenSSL
if [ ! -e ${rvm_path}/usr/bin/openssl ] ;then
  rvm pkg install openssl
fi

rvm install $RUBY_VERSION --default
rvm install 2.7.3 --with-openssl-dir=$HOME/.rvm/usr
rvm install 2.4.10 --with-openssl-dir=$HOME/.rvm/usr

gem install bundle
bundle update
