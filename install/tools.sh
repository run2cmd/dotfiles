#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
tools_dir=${HOME}/tools
source ${libdir}/lib.sh

topic 'UPDATE DEVELOPMENT TOOLS'

if [ ! -e /home/linuxbrew ] ;then
  task 'Install Homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

task 'Update brew packages'

brew update

brewpkgs=(hadolint k9s helm helm-ls tflint golangci-lint marksman lua-language-server argocd lazygit yq kubectl)

for pkg in "${brewpkgs[@]}" ;do
  brew install $pkg
done

brew upgrade

install_puppet_editor_services() {
  task "Update puppet editor services (LSP)"
  dir_path=${tools_dir}/puppet-editor-services
  git_clone https://github.com/puppetlabs/puppet-editor-services.git $dir_path
  if [ "$(git_check_update ${dir_path} Gemfile.lock)" == "1" ] ;then
    git -C ${dir_path} pull
    bundle install --gemfile=${dir_path}/Gemfile
    bundle exec rake -f ${dir_path}/Rakefile gem_revendor
    ln -snf ${dir_path}/puppet-languageserver ~/bin/puppet-languageserver
  fi
}

install_lemminx() {
  task "Update lemminx (XML LSP)"
  declare -A data="$(git_data redhat-developer/vscode-xml linux.zip)"
  bin_file=${HOME}/bin/lemminx
  if [ ! -e ${bin_file} ] || ! (grep -q ${data[version]} ${HOME}/tools/lemminx.version) ;then
    echo ${data[version]} > ${HOME}/tools/lemminx.version
    wget -q -O /tmp/lemminx.zip ${data[url]}
    unzip -q /tmp/lemminx.zip -d /tmp/
    mv -f /tmp/lemminx-linux ${bin_file}
  fi
}

install_lemminx
install_puppet_editor_services
