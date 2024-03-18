#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh
# shellcheck disable=SC2046
repodir=$(dirname $(dirname "$(readlink -f $0)"))

topic 'SETUP WINDOWS TOOLS CONFIGURATION'
cp ${repodir}/viebrc /mnt/c/Users/${USER}/.viebrc
cp ${repodir}/wezterm.lua /mnt/c/Users/${USER}/.wezterm.lua
cp ${repodir}/winbin/* /mnt/c/Users/${USER}/bin/
cp -rf ${repodir}/vieb /mnt/c/Users/${USER}/
