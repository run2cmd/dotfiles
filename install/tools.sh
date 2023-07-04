#!/bin/bash
#
# Update tools for development.
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh

topic 'UPDATE DEVELOPMENT TOOLS'

task 'Update hadolint'
HADOLINT_DATA=$(git_data https://api.github.com/repos/hadolint/hadolint/releases/latest)
if ! (hadolint --version | grep -q "$(echo ${HADOLINT_DATA} | cut -d' ' -f1)") ;then
 wget -q -O ${HOME}/bin/hadolint "$(echo ${HADOLINT_DATA} | cut -d' ' -f2)"
 chmod +x ${HOME}/bin/hadolint
fi

task "Update k9s"
K9S_DATA=$(git_data https://api.github.com/repos/derailed/k9s/releases/latest)
if ! (k9s version |grep -q "$(echo ${K9S_DATA} | cut -d' ' -f1)") ;then
 wget -q -O /tmp/k9s.tar.gz "$(echo ${K9S_DATA} | cut -d' ' -f2)"
 tar -xvf /tmp/k9s.tar.gz -C ${HOME}/bin k9s
fi

task "Update helm"
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
