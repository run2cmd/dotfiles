#!/bin/bash
#
# Run installation and stup of the project.
#
libdir=$(dirname "$(readlink -f $0)")

${libdir}/install/dependencies.sh
${libdir}/install/system.sh
${libdir}/install/tools.sh
${libdir}/install/dotfiles.sh
${libdir}/install/ruby.sh
${libdir}/install/python.sh
${libdir}/install/sdkman.sh
${libdir}/install/node.sh
${libdir}/install/neovim.sh
${libdir}/install/windows.sh
