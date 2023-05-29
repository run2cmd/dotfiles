#!/bin/bash
#
# Update operating system and install required tools.
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh

topic 'UPDATE OPERATING SYSTEM'

sudo apt update -q

TO_INSTALL=''
while read -r line ;do
  if ! (dpkg -l | grep -q " ${line} ") ;then
    TO_INSTALL="${TO_INSTALL} ${line}"
  fi
done < ${HOME}/Pkgfile

if [ "${TO_INSTALL}" != '' ] ;then
  sudo apt -q install -y $TO_INSTALL
fi

sudo apt upgrade -q -y && sudo apt autoremove -y

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
