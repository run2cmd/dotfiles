#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh

topic 'INSTALL DEPENDENCIES'

dep_pkgs=(curl wget apt-transport-https build-essential)
for pkg in "${dep_pkgs[@]}" ;do
  dpkg -l | grep -q " ${pkg} " || sudo apt install -qu ${pkg}
done
