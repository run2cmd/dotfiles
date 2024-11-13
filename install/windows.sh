#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
source ${libdir}/lib.sh
# shellcheck disable=SC2046
repodir=$(dirname $(dirname "$(readlink -f $0)"))

topic 'SETUP WINDOWS TOOLS CONFIGURATION'
cp ${repodir}/wezterm.lua /mnt/c/Users/${USER}/.wezterm.lua
