#!/bin/bash

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
ln -snf /etc/ssl/certs/java/cacerts ${HOME}/.sdkman/candidates/java/11.0.12-open/lib/security/cacerts
sdk install java 17.0.2-open
ln -snf /etc/ssl/certs/java/cacerts ${HOME}/.sdkman/candidates/java/17.0.2-open/lib/security/cacerts
sdk install groovy 2.4.12
sdk install maven
sdk install gradle


mkdir -p ${HOME}/.config/codenarc
wget -q -O ${HOME}/.config/codenarc/StarterRuleSet-AllRules.groovy https://raw.githubusercontent.com/CodeNarc/CodeNarc/master/docs/StarterRuleSet-AllRules.groovy.txt

task "Cleanup after update"
sdk flush metadata
sdk flush tmp
sdk flush version

for app in maven gradle ;do
  candidates_root=${HOME}/.sdkman/candidates/${app}
  curr_ver=$(readlink ${candidates_root}/current)
  app_to_remove=$(ls --color=never ${candidates_root} | grep -Ev "${curr_ver}|current")
  for ver in $app_to_remove ;do
    echo "Remove ${ver}"
    rm -rf ${candidates_root}/${ver}
  done
done
