#!/bin/bash
#
# Install Ruby
#
libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh

topic 'UPDATE RUBY'

default_ruby=3.2.2
additional_rubies='2.7.3 2.4.10 2.0.0'

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

for rb in $additional_rubies ;do
  rvm install ${rb} --with-openssl-dir=${rvm_path}/usr
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
  rm -rf ${rubies_path}/${rb}
done
