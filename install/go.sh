#!/bin/bash
#
# Install Golang
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh
TOOLSDIR=${HOME}/tools

topic 'UPDATE GOLANG'
mkdir -p ${TOOLSDIR}/go
for ver in 1.20.5 ;do
  GO_TAR=go${ver}.linux-amd64.tar.gz
  if [ ! -e ${TOOLSDIR}/go/${ver} ] ;then
    mkdir -p ${TOOLSDIR}/go/${ver}
    wget -q -O /tmp/${GO_TAR} https://go.dev/dl/${GO_TAR}
    tar -xvf /tmp/${GO_TAR} -C ${TOOLSDIR}/go/${ver}
  fi
done

ln -s ${TOOLSDIR}/go/1.20.5 ${TOOLSDIR}/go/main
