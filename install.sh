#!/bin/bash
#
# Run installation and stup of the project.
#
LIBDIR=$(dirname "$(readlink -f $0)")

${LIBDIR}/install/dependencies.sh
${LIBDIR}/install/system.sh
${LIBDIR}/install/dotfiles.sh
${LIBDIR}/install/neovim.sh
${LIBDIR}/install/ruby.sh
${LIBDIR}/install/python.sh
${LIBDIR}/install/sdkman.sh
${LIBDIR}/install/nodejs.sh
${LIBDIR}/install/lsp.sh
${LIBDIR}/install/windows.sh
