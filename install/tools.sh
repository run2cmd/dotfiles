#!/bin/bash

libdir=$(dirname "$(readlink -f $0)")
tools_dir=${HOME}/tools
source ${libdir}/lib.sh

topic 'UPDATE DEVELOPMENT TOOLS'

task 'Update hadolint'
hadolint_data="$(git_data https://api.github.com/repos/hadolint/hadolint/releases/latest)"
hadolint_version="$(git_version "${hadolint_data}")"
hadolint_url="$(git_url "${hadolint_data}" hadolint-Linux-x86_64)"
if ! (hadolint --version | grep -q "${hadolint_version//v/}") ;then
  wget -q -O ${HOME}/bin/hadolint "${hadolint_url}"
  chmod +x ${HOME}/bin/hadolint
fi

task "Update k9s"
k9s_data="$(git_data https://api.github.com/repos/derailed/k9s/releases/latest)"
k9s_version="$(git_version "${k9s_data}")"
k9s_url="$(git_url "${k9s_data}" k9s_Linux_amd64.tar.gz)"
if ! (k9s version |grep -q "${k9s_version}") ;then
  wget -q -O /tmp/k9s.tar.gz "${k9s_url}"
  tar -xvf /tmp/k9s.tar.gz -C ${HOME}/bin k9s
fi

task "Update helm"
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

task "Update helm LSP"
helmls_file=${HOME}/bin/helm_ls
helmls_sha_match="$(match_sha256sum https://github.com/mrjosh/helm-ls/releases/download/master/helm_ls_linux_amd64.sha256sum ${helmls_file})"
if [ -e ${helmls_file} ] || [ ${helmls_sha_match} == 'no-match' ] ;then
  wget -q -O ${HOME}/bin/helm_ls https://github.com/mrjosh/helm-ls/releases/download/master/helm_ls_linux_amd64
  chmod +x ${HOME}/bin/helm_ls
fi

task "Update tflint"
tflint_version="$(git_version "$(git_data https://api.github.com/repos/terraform-linters/tflint/releases/latest)")"
if ! (tflint --version | grep -q "${tflint_version//v/}") ;then
  curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
fi

task "Update golangci-lint"
golang_version="$(git_version "$(git_data https://api.github.com/repos/golangci/golangci-lint/releases/latest)")"
if (golangci-lint --version | grep -q ${golang_version//v/}) ;then
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s ${golang_version}
fi
go install github.com/nametake/golangci-lint-langserver@latest

task "Update marksman (Markdown LSP)"
md_data="$(git_data https://api.github.com/repos/artempyanykh/marksman/releases/latest)"
md_version="$(git_version "${md_data}")"
md_url="$(git_url "${md_data}" marksman-linux-x64)"
if ! (grep -q "${md_version}" ${HOME}/tools/marksman.version) ;then
  echo ${md_version} > ${HOME}/tools/marksman.version
  wget -q -O ${HOME}/bin/marksman "${md_url}"
  chmod +x ${HOME}/bin/marksman
fi

task "Update puppet editor services (LSP)"
puppet_dir=${tools_dir}/puppet-editor-services
git_clone https://github.com/puppetlabs/puppet-editor-services.git $puppet_dir
if [ "$(git_check_update ${puppet_dir} Gemfile.lock)" == "1" ] ;then
  git -C ${puppet_dir} pull
  bundle install --gemfile=${puppet_dir}/Gemfile
  bundle exec rake -f ${puppet_dir}/Rakefile gem_revendor
  ln -snf ${puppet_dir}/puppet-languageserver ~/bin/puppet-languageserver
fi

task "Update Lua Language Server"
lua_data="$(git_data https://api.github.com/repos/LuaLS/lua-language-server/releases/latest)"
lua_version="$(git_version "${lua_data}")"
lua_url="$(git_url "${lua_data}" lua-language-server-${lua_version}-linux-x64.tar.gz)"
lua_dir=${tools_dir}/lua-language-server
mkdir -p $lua_dir
if ! (luals.sh --version | grep -q "${lua_version}") ;then
  wget -q -O /tmp/luals.tar.gz "${lua_url}"
  tar -xf /tmp/luals.tar.gz -C $lua_dir \
    && echo "exec \"${lua_dir}/bin/lua-language-server\" \"\$@\"" > ~/bin/luals.sh \
    && chmod +x ~/bin/luals.sh
fi

task "Update lemminx (XML LSP)"
lemminx_bin=${HOME}/bin/lemminx
lemminx_sha_match="$(match_sha256sum https://github.com/redhat-developer/vscode-xml/releases/download/latest/lemminx-linux.sha256 ${lemminx_bin})"
if [ -e ${lemminx_bin} ] || [ ${lemminx_sha_match} == 'no-match' ] ;then
  wget -q -O /tmp/lemminx.zip https://github.com/redhat-developer/vscode-xml/releases/download/latest/lemminx-linux.zip
  unzip -q /tmp/lemminx.zip -d /tmp/
  mv -f /tmp/lemminx-linux ${lemminx_bin}
fi

task "Install Azure CLI"
if which az ;then
  echo "Already installed. Updates through apt during system update."
else
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

task "Update terragrunt"
tg_data="$(git_data https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest)"
tg_version="$(git_version "${tg_data}")"
tg_url="$(git_url "${tg_data}" terragrunt_linux_amd64)"
if ! (grep -q "${tg_version}" ${HOME}/tools/terragrunt.version) ;then
  echo ${tg_version} > ${HOME}/tools/terragrunt.version
  wget -q -O ${HOME}/bin/terragrunt "${tg_url}"
  chmod +x ${HOME}/bin/terragrunt
fi
