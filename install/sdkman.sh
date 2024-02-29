#!/bin/bash
#
# Install Sdkman and tools.
#
libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh

topic 'UPDATE SDKMAN'

if [ ! -e ${HOME}/.sdkman ] ;then
 curl -s 'https://get.sdkman.io' | bash
fi

# shellcheck disable=SC1091
source "${HOME}/.sdkman/bin/sdkman-init.sh"

sdk update
sdk install java 11.0.12-open
sdk install groovy 2.4.12
sdk install maven && sdk install gradle

# Update certificates
ln -snf /etc/ssl/certs/java/cacerts ${HOME}/.sdkman/candidates/java/current/lib/security/cacerts

# Add npm-groovy-lint starter rule set
mkdir -p ${HOME}/.config/codenarc
wget -q -O ${HOME}/.config/codenarc/StarterRuleSet-AllRules.groovy https://raw.githubusercontent.com/CodeNarc/CodeNarc/master/docs/StarterRuleSet-AllRules.groovy.txt

task "Cleanup after update"
sdk flush metadata
sdk flush tmp
sdk flush version

for app in ${HOME}/.sdkman/candidates/* ;do
  curr_ver=$(readlink ${app}/current)
  app_to_remove=$(ls --color=never $app | grep -Ev "${curr_ver}|current")
  for ver in $app_to_remove ;do
    echo "Remove ${ver}"
    rm -rf ${app}/${ver}
  done
done
