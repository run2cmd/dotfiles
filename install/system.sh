#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
repodir=$(dirname $(dirname "$(readlink -f $0)"))
source ${libdir}/lib.sh

topic 'UPDATE OPERATING SYSTEM'

# sudo apt clean && sudo apt update -q
#
# to_install=''
# while read -r line ;do
#   if ! (dpkg -l | grep -q " ${line} ") ;then
#     to_install="${to_install} ${line}"
#   fi
# done < ${HOME}/Pkgfile
#
# if [ "${to_install}" != '' ] ;then
#   sudo apt -q install --allow-downgrades -y $to_install
# fi
#
# sudo apt upgrade -q -y && sudo apt full-upgrade --allow-downgrades -q -y && sudo apt autoremove -y

if ! diff ${repodir}/wsl.conf /etc/wsl.conf &> /dev/null ;then
  echo 'Update /etc/wsl.conf. WSL reboot required.'
  sudo cp -f ${repodir}/wsl.conf /etc/wsl.conf
fi
