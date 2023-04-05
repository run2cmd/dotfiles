#!/bin/bash
#
# Install windows configuration files
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh
REPODIR=$(dirname $(dirname "$(readlink -f $0)"))

topic 'SETUP WINDOWS TOOLS CONFIGURATION'
cp ${REPODIR}/viebrc /mnt/c/Users/${USER}/.viebrc
cp ${REPODIR}/wezterm.lua /mnt/c/Users/${USER}/.wezterm.lua
