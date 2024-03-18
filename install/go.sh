#!/bin/bash
libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh
toolsdir=${HOME}/tools

topic 'UPDATE GOLANG'

# Space separated versions
default_ver='1.20.5'
go_versions="1.20.5"

mkdir -p ${toolsdir}/go
for ver in $go_versions ;do
  gotar=go${ver}.linux-amd64.tar.gz
  if [ ! -e ${toolsdir}/go/${ver} ] ;then
    mkdir -p ${toolsdir}/go/${ver}
    wget -q -O /tmp/${gotar} https://go.dev/dl/${gotar}
    tar -xvf /tmp/${gotar} -C ${toolsdir}/go/${ver}
  fi
done

ln -s ${toolsdir}/go/${default_ver} ${toolsdir}/go/main
