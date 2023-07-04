#!/bin/bash
#
# Install and/or update required dependencies for other tools.
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh

topic 'INSTALL DEPENDENCIES'

DEP_PKG_LIST=(curl wget apt-transport-https)
for pkg in "${DEP_PKG_LIST[@]}" ;do
  dpkg -l | grep -q " ${pkg} " || sudo apt install -qu ${pkg}
done

if ! (apt-cache policy | grep -q hashicorp) ;then
  wget -q -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi
