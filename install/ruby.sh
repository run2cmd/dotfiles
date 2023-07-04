#!/bin/bash
#
# Install Ruby
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh

topic 'UPDATE RUBY'

RUBY_VERSION=2.7.8

if [ ! -e ${HOME}/.rvm ] ;then
  curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
  curl -sSL https://get.rvm.io | bash -s stable --version $RUBY_VERSION
  source '/home/pbugala/.rvm/scripts/rvm'
fi

rvm get stable

rvm install $RUBY_VERSION --default
rvm install 2.7.3
rvm install 2.4.10

gem install bundle
bundle update
