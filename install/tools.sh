#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
tools_dir=${HOME}/tools
source ${libdir}/lib.sh

topic 'UPDATE DEVELOPMENT TOOLS'

function install_hadolint() {
  task 'Update hadolint'
  declare -A data="$(git_data https://api.github.com/repos/hadolint/hadolint/releases/latest hadolint-Linux-x86_64)"
  if ! (hadolint --version | grep -q ${data[version]//v/}) ;then
    wget -q -O ${HOME}/bin/hadolint ${data[url]}
    chmod +x ${HOME}/bin/hadolint
  fi
}

function install_k9s() {
  task "Update k9s"
  declare -A data="$(git_data https://api.github.com/repos/derailed/k9s/releases/latest k9s_Linux_amd64.tar.gz)"
  if ! (k9s version |grep -q ${data[version]}) ;then
    wget -q -O /tmp/k9s.tar.gz ${data[url]}
    tar -xvf /tmp/k9s.tar.gz -C ${HOME}/bin k9s
  fi
}

function install_helm() {
  task "Update helm"
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

function install_helm_lsp() {
  task "Update helm LSP"
  file_name=${HOME}/bin/helm_ls
  sha_match="$(match_sha256sum https://github.com/mrjosh/helm-ls/releases/download/master/helm_ls_linux_amd64.sha256sum ${file_name})"
  if [ -e ${file_name} ] || [ ${sha_match} == 'no-match' ] ;then
    wget -q -O ${HOME}/bin/helm_ls https://github.com/mrjosh/helm-ls/releases/download/master/helm_ls_linux_amd64
    chmod +x ${HOME}/bin/helm_ls
  fi
}

function install_tflint() {
  task "Update tflint"
  declare -A data="$(git_data https://api.github.com/repos/terraform-linters/tflint/releases/latest)"
  if ! (tflint --version | grep -q ${data[version]//v/}) ;then
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
  fi
}

function install_golangci_lint() {
  task "Update golangci-lint"
  declare -A data="$(git_data https://api.github.com/repos/golangci/golangci-lint/releases/latest)"
  if (golangci-lint --version | grep -q ${data[version]//v/}) ;then
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s ${version}
  fi
  go install github.com/nametake/golangci-lint-langserver@latest
}

function install_marksman() {
  task "Update marksman (Markdown LSP)"
  declare -A data="$(git_data https://api.github.com/repos/artempyanykh/marksman/releases/latest marksman-linux-x64)"
  if ! (grep -q ${data[version]} ${HOME}/tools/marksman.version) ;then
    echo ${data[version]} > ${HOME}/tools/marksman.version
    wget -q -O ${HOME}/bin/marksman ${data[url]}
    chmod +x ${HOME}/bin/marksman
  fi
}

function install_puppet_editor_services() {
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

function install_lua_lsp() {
  task "Update Lua Language Server"
  declare -A data="$(git_data https://api.github.com/repos/LuaLS/lua-language-server/releases/latest lua-language-server-${version}-linux-x64.tar.gz)"
  dir_name=${tools_dir}/lua-language-server
  mkdir -p $dir_name
  if ! (luals.sh --version | grep -q ${data[version]}) ;then
    wget -q -O /tmp/luals.tar.gz ${data[url]}
    tar -xf /tmp/luals.tar.gz -C $dir_name \
      && echo "exec \"${dir_name}/bin/lua-language-server\" \"\$@\"" > ~/bin/luals.sh \
      && chmod +x ~/bin/luals.sh
  fi
}

function install_lemminx() {
  task "Update lemminx (XML LSP)"
  bin_file=${HOME}/bin/lemminx
  sha_match="$(match_sha256sum https://github.com/redhat-developer/vscode-xml/releases/download/latest/lemminx-linux.sha256 ${bin_file})"
  if [ -e ${bin_file} ] || [ ${sha_match} == 'no-match' ] ;then
    wget -q -O /tmp/lemminx.zip https://github.com/redhat-developer/vscode-xml/releases/download/latest/lemminx-linux.zip
    unzip -q /tmp/lemminx.zip -d /tmp/
    mv -f /tmp/lemminx-linux ${bin_file}
  fi
}

function install_argocd_cli() {
  task "Update ArgoCD CLI"
  declare -A data="$(git_data https://api.github.com/repos/argoproj/argo-cd/releases/latest)"
  bin_file=${HOME}/bin/argocd
  if ! (argocd version --client | head -1 | grep -q ${data[version]}) ;then
    rm -f ${bin_file}
    wget -q -O ${bin_file} https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    chmod +x ${bin_file}
  fi
}

install_k9s
install_helm
install_helm_lsp
install_tflint
install_lua_lsp
install_lemminx
install_hadolint
install_marksman
install_golangci_lint
install_puppet_editor_services
install_argocd_cli
