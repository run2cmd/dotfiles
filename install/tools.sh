#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
tools_dir=${HOME}/tools
source ${libdir}/lib.sh

topic 'UPDATE DEVELOPMENT TOOLS'

function install_hadolint() {
  task 'Update hadolint'
  declare -A data="$(git_data hadolint/hadolint hadolint-Linux-x86_64)"
  bin_file="${HOME}/bin/hadolint"
  if [ ! -e ${bin_file} ] || ! (hadolint --version | grep -q ${data[version]//v/}) ;then
    rm -f ${bin_file}
    wget -q -O ${bin_file} ${data[url]}
    chmod +x ${bin_file}
  fi
}

function install_k9s() {
  task "Update k9s"
  declare -A data="$(git_data derailed/k9s k9s_Linux_amd64.tar.gz)"
  if [ ! -e ${HOME}/bin/k9s ] || ! (k9s version |grep -q ${data[version]}) ;then
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
  declare -A data="$(git_data mrjosh/helm-ls helm_ls_linux_amd64)"
  bin_file=${HOME}/bin/helm_ls
  if [ ! -e ${bin_file} ] || ! (grep -q ${data[version]} ${HOME}/tools/helm_lsp.version) ;then
    rm -f ${bin_file}
    echo ${data[version]} > ${HOME}/tools/helm_lsp.version
    wget -q -O ${bin_file} ${data[url]}
    chmod +x ${bin_file}
  fi
}

function install_tflint() {
  task "Update tflint"
  declare -A data="$(git_data terraform-linters/tflint)"
  if ! (command -v tflint &> /dev/null) || ! (tflint --version | grep -q ${data[version]//v/}) ;then
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
  fi
}

function install_golangci_lint() {
  task "Update golangci-lint"
  declare -A data="$(git_data golangci/golangci-lint)"
  if ! (command -v golangci-lint &> /dev/null) || ! (golangci-lint --version | grep -q ${data[version]//v/}) ;then
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s ${data[version]}
    go install github.com/nametake/golangci-lint-langserver@latest
  fi
}

function install_marksman() {
  task "Update marksman (Markdown LSP)"
  declare -A data="$(git_data artempyanykh/marksman marksman-linux-x64)"
  bin_file=${HOME}/bin/marksman
  if [ ! -e ${bin_file} ] || ! (grep -q ${data[version]} ${HOME}/tools/marksman.version) ;then
    rm -f ${bin_file}
    echo ${data[version]} > ${HOME}/tools/marksman.version
    wget -q -O ${bin_file} ${data[url]}
    chmod +x ${bin_file}
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
  declare -A data="$(git_data LuaLS/lua-language-server linux-x64.tar.gz)"
  dir_name=${tools_dir}/lua-language-server
  bin_file=${HOME}/bin/luals.sh
  mkdir -p $dir_name
  if [ ! -e ${bin_file} ] || ! (luals.sh --version | grep -q ${data[version]}) ;then
    rm -f ${bin_file}
    wget -q -O /tmp/luals.tar.gz ${data[url]}
    tar -xf /tmp/luals.tar.gz -C ${dir_name} \
      && echo "exec \"${dir_name}/bin/lua-language-server\" \"\$@\"" > ${bin_file} \
      && chmod +x ${bin_file}
  fi
}

function install_lemminx() {
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

function install_argocd_cli() {
  task "Update ArgoCD CLI"
  declare -A data="$(git_data argoproj/argo-cd linux-amd64)"
  bin_file=${HOME}/bin/argocd
  if [ ! -e ${bin_file} ] || ! (argocd version --client | head -1 | grep -q ${data[version]}) ;then
    rm -f ${bin_file}
    wget -q -O ${bin_file} ${data[url]}
    chmod +x ${HOME}/bin/argocd
  fi
}

function install_lazygit() {
  task 'Update lazygit'
  declare -A data="$(git_data jesseduffield/lazygit Linux_x86_64.tar.gz)"
  bin_file=${HOME}/bin/lazygit
  if [ ! -e ${bin_file} ] || ! (lazygit --version | grep -q ${data[version]//v/}) ;then
    rm -f ${bin_file}
    wget -q -O /tmp/lazygit.tar.gz ${data[url]}
    tar -xvf /tmp/lazygit.tar.gz -C ${HOME}/bin lazygit
  fi
}

function install_yq() {
  task 'Update yq (yaml processor)'
  declare -A data="$(git_data mikefarah/yq yq_linux_amd64)"
  bin_file=${HOME}/bin/yq
  if [ ! -e ${bin_file} ] || ! (yq --version | grep -q ${data[version]}) ; then
    rm -f ${bin_file}
    wget -q -O $bin_file ${data[url]}
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
install_lazygit
install_yq
