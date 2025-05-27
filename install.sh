#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")

mkdir -p ${HOME}/bin
ln -snf ${libdir}/install.sh ${HOME}/bin/dotfiles-update

INSTALL_TYPE=$1

case $INSTALL_TYPE in
  all)
    ${libdir}/install/dependencies.sh
    ${libdir}/install/system.sh
    ${libdir}/install/tools.sh
    ${libdir}/install/dotfiles.sh
    ${libdir}/install/ruby.sh
    ${libdir}/install/python.sh
    ${libdir}/install/sdkman.sh
    ${libdir}/install/node.sh
    ${libdir}/install/tfsuite.sh
    ${libdir}/install/neovim.sh
  ;;
  system)
    ${libdir}/install/system.sh
  ;;
  tools)
    ${libdir}/install/tools.sh
  ;;
  dotfiles)
    ${libdir}/install/dotfiles.sh
  ;;
  ruby)
    ${libdir}/install/ruby.sh
  ;;
  python)
    ${libdir}/install/python.sh
  ;;
  sdk)
    ${libdir}/install/sdkman.sh
  ;;
  nodejs)
    ${libdir}/install/node.sh
  ;;
  neovim)
    ${libdir}/install/neovim.sh
  ;;
  tfsuite)
    ${libdir}/install/tfsuite.sh
  ;;
  *)
    echo "
    Usage: dotfiles-update [INSTALL_TYPE]
    Installation types available:
      all - Run complex installation/update of everything. If this is 1st installtion you need to choose this option.
      system - System OS update.
      tools - Custom tools update that are not available through system package system.
      dotfiles - Install dotfiles.
      ruby - Update rubies.
      python - Update python.
      sdk - Update SDKMAN tools.
      nodejs - Update NodeJS.
      neovim - Update Neovim.
      tfsuite - Terraform and Terragrunt.
    "
  ;;
esac
