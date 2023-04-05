#!/bin/bash
#
# Install Ruby
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh

topic 'UPDATE RUBY'

if [ ! -e ${HOME}/.rvm ] ;then
 curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
 curl -sSL https://get.rvm.io | bash -s stable --version 2.4.10
 source '/home/pbugala/.rvm/scripts/rvm'
fi

rvm get stable
rvm install 2.7.3 --default
rvm install 2.4.10
gem install bundle
bundle update
