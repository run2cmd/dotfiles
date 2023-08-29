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
ln -snf /etc/ssl/certs/java/cacerts ${HOME}/.sdkman/candidates/java/current/lib/security/cacerts
