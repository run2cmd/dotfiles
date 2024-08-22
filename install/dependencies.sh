#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh

topic 'INSTALL DEPENDENCIES'

dep_pkgs=(curl wget apt-transport-https build-essential)
for pkg in "${dep_pkgs[@]}" ;do
  dpkg -l | grep -q " ${pkg} " || sudo apt install -qu ${pkg}
done

if ! (apt-cache policy | grep -q hashicorp) ;then
  wget -q -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi
