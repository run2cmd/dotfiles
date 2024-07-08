#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh

topic 'UPDATE OPERATING SYSTEM'

sudo apt update -q

to_install=''
while read -r line ;do
  if ! (dpkg -l | grep -q " ${line} ") ;then
    to_install="${to_install} ${line}"
  fi
done < ${HOME}/Pkgfile

if [ "${to_install}" != '' ] ;then
  sudo apt -q install --allow-downgrades -y $to_install
fi

sudo apt upgrade --allow-downgrades -q -y && sudo apt autoremove -y
