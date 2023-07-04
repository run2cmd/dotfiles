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
