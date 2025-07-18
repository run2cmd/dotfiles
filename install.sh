#!/bin/bash
# shellcheck extended-analysis=false

WORKDIR=${HOME}

REPODIR=$(dirname "$(readlink -f $0)")
TOOLS_DIR=${HOME}/tools
CONFIG_FILE=${REPODIR}/config.yaml
INSTALL_TYPE=$1

mkdir -p ${HOME}/bin
ln -snf ${REPODIR}/install.sh ${HOME}/bin/dotfiles-update

topic() {
  echo "$(tput bold)$(tput setaf 4)${1}$(tput sgr0)"
}

yaml_value() {
  yq -r "${1}" $CONFIG_FILE
}

yaml_keys() {
  yaml_value "${1} | keys | join(\" \")"
}

yaml_array() {
  yaml_value "${1} | join(\" \")"
}

dependencies() {
  topic 'Install dependencies'
  local dep_pkgs
  dep_pkgs=(curl wget apt-transport-https build-essential jq yq)
  for pkg in "${dep_pkgs[@]}" ;do
    dpkg -l | grep -q " ${pkg} " || sudo apt install -qu ${pkg}
  done
}

setup_dotfiles() {
  topic 'Setup dotfiles'

  for mdir in $(yaml_array '.dotfiles.dirs') ;do
    mkdir -p ${mdir}
  done

  for mlink in $(yaml_keys '.dotfiles.links') ;do
    ln -snf ${REPODIR}/${mlink} ${HOME}/$(yaml_value ".dotfiles.links[\"${mlink}\"]")
  done

  if ! grep -q 'dotfiles' ${HOME}/.bashrc ;then
   echo '# Laod dotfiles setup' >> ${HOME}/.bashrc
   # shellcheck disable=SC2016
   echo 'source ${HOME}/dotfiles/bashrc' >> ${HOME}/.bashrc
  fi

  # shellcheck disable=SC2016
  [ ! -e ${HOME}/.bash_profile ] && echo '[ -s "$HOME/.profile" ] && source "$HOME/.profile"' > ${HOME}/.bash_profile

  # shellcheck source=./bashrc
  source ${HOME}/.bashrc
}

install_neovim() {
  topic 'Update neovim'
  local url image_file appfile git_sha file_sha

  url=https://github.com/neovim/neovim/releases/latest/download
  image_file=nvim-linux-x86_64.appimage
  appfile=${TOOLS_DIR}/nvim.appimage
  git_sha="$(wget -qO- ${url}/nvim.appimage.sha256sum | cut -d' ' -f1)"
  file_sha="$(sha256sum ${appfile} | cut -d' ' -f1)"
  if [ ! -e ${appfile} ] || [ "${git_sha}" != "${file_sha}" ] ;then
    wget -q -O ${appfile} ${url}/${image_file}
    # shellcheck disable=SC2046
    [ $(wc -l ${appfile} | cut -d" " -f1) -eq 0 ] && echo "Failed to download ${url}/${image_file}" && exit 1
    chmod u+x ${appfile}
    ${appfile} --version
    # shellcheck source=./bashrc
    source ${HOME}/.bashrc
  fi
  ln -snf ${appfile} ${HOME}/bin/nvim
}

install_neovim_plugins() {
  topic "Update Neovim plugins"
  local timestamp_file last_update pm_path

  pm_path="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
  if [ ! -e ${pm_path} ] ;then
    git clone --depth=1 https://github.com/savq/paq-nvim.git ${pm_path}
  fi

  timestamp_file=~/.local/share/nvim/plugins_timestamp
  if ! test -f ${timestamp_file} ;then date +%Y-%m-%d > ${timestamp_file} ;fi
  last_update=$(cat ${timestamp_file})
  nvim --headless -c 'autocmd User PaqDoneSync quitall' -c 'PaqSync'
  for i in $(fdfind --type d --exact-depth 2 . ~/.local/share/nvim/site/pack/paqs) ;do
    echo "-> Update $(basename ${i})"
    git --git-dir ${i}/.git log --oneline --since="${last_update}"
  done
  date +%Y-%m-%d > ${timestamp_file}

  topic "Update Neovim treesitter"
  nvim --headless -c 'TSUpdateSync | quitall'
  echo ""
}

setup_node() {
  topic 'Update nodejs'
  local node_path

  # shellcheck source=../.nvm/nvm.sh
  source "${HOME}/.nvm/nvm.sh"

  if [ ! -e ${HOME}/.nvm ] ; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$(yaml_value '.nvm.version')/install.sh | bash
    # shellcheck source=./bashrc
    source ${HOME}/.bashrc
  fi

  cd $WORKDIR || exit 1

  nvm install node
  for nver in $(yaml_array '.nvm.nodeVersions') ;do
    nvm install $nver
  done
  nvm alias default node
  nvm use node
  npm install
  npm install -g
  npm update
  npm link
}

nodejs_cleanup() {
  topic "Cleanup nodejs after update"
  local  node_to_remove
  nvm cache clear
  node_path=${HOME}/.nvm/versions/node
  node_to_remove=$(ls --color=never $node_path | grep -Ev "$(node --version)")
  for n in $node_to_remove ;do
    echo "Remove ${n}"
    rm -rf ${node_path:?}/${n}
  done
}

setup_pyenv() {
  topic 'Update pyenv'

  export PYTHON_CONFIGURE_OPTS="--enable-shared"

  if [ ! -e ${HOME}/.pyenv ] ;then
    curl -fsSL https://pyenv.run | bash
    # shellcheck source=./bashrc
    source ${HOME}/.bashrc
  fi
  pyenv update
}

install_python() {
  topic 'Install python'
  local pydefault

  pydefault=$(yaml_value '.pyenv.pythonVersion')
  pyenv install -s $pydefault
  for pyver in $(yaml_array '.pyenv.extraPythonVersions') ;do
    pyenv install -s $pyver
  done

  export CPPFLAGS="-I/usr/include/openssl"
  export LDFLAGS="-L/usr/lib/x86_64-linux-gnu"
  pyenv global $pydefault
  cd ~/.pyenv && src/configure && make -C src
  cd $WORKDIR || exit 1
}

update_pip() {
  topic 'Update Python packages'
  pip install -r ${REPODIR}/Pythonfile --upgrade
  type gita &> /dev/null && wget -q -O ${HOME}/.bash_completion.d/gita_completion https://github.com/nosarthur/gita/blob/master/.gita-completion.bash
}

install_ansible_galaxy() {
  ansible-galaxy collection install community.general
}

python_cleanup() {
  topic "Cleanup python after update"
  pip cache purge
}

setup_rvm() {
  # shellcheck source=./bashrc
  source ${HOME}/.bashrc

  topic 'Update rvm'
  if [ ! -e ${HOME}/.rvm ] ;then
    gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
  fi

  # shellcheck source=../.rvm/scripts/rvm
  source "${HOME}/.rvm/scripts/rvm"

  rvm get stable
  rvm autolibs enable

  # shellcheck disable=SC2154
  if [ ! -e ${rvm_path}/usr/bin/openssl ] ;then
    rvm pkg install openssl
  fi

  if [ ! -L "${rvm_path}/usr/ssl" ] ;then
    sudo mv ${rvm_path}/usr/ssl ${rvm_path}/usr/ssl_orig
    sudo ln -s /usr/lib/ssl ${rvm_path}/usr/ssl
  fi
}

install_rubies() {
  # shellcheck disable=SC1091
  source "${HOME}/.rvm/scripts/rvm"
  local rbver

  topic 'Install rubies'
  rbver=$(yaml_value '.rvm.rubyVersion')

  rvm install $rbver --default

  for rb in $(yaml_array '.rvm.extraRubiesVersions') ;do
    rvm install ${rb} --with-openssl-dir=${rvm_path}/usr --autolibs=disable
    rvm use ${rb}
    BUNDLE_GEMFILE=${REPODIR}/Gemfile_${rb} gem install bundle
    BUNDLE_GEMFILE=${REPODIR}/Gemfile_${rb} bundle install
  done

  topic "Update default ruby"
  rvm use $rbver
  gem install bundle
  gem update --system
  bundle update
}

rvm_cleanup() {
  topic "Cleanup rvm after update"
  local rbver
  rbver=$(yaml_value '.rvm.rubyVersion')

  rvm cleanup all
  rubies_path=${HOME}/.rvm/rubies
  rubies_to_remove=$(ls --color=never $rubies_path | grep -Ev "${rbver}|$(yaml_value '.rvm.extraRubiesVersions | join("|")')|default")
  for rb in $rubies_to_remove ;do
    echo "Remove ${rb}"
    rm -rf ${rubies_path:?}/${rb}
  done
}

install_puppet_lsp() {
  topic "Update puppet editor services (LSP)"
  dir_path=${TOOLS_DIR}/puppet-editor-services
  [ ! -e ${dir_path} ] && git clone https://github.com/puppetlabs/puppet-editor-services.git ${dir_path}
  if [ ! -e "${dir_path}/Gemfile.lock" ] || git -C ${dir_path} remote show origin | grep 'out of date' ;then
    cd ${dir_path} || exit 1
    git reset --hard main
    git pull
    bundle install --gemfile=${dir_path}/Gemfile
    bundle exec rake -f ${dir_path}/Rakefile gem_revendor
    cd $WORKDIR || exit 1
    ln -snf ${dir_path}/puppet-languageserver ~/bin/puppet-languageserver
  fi
}

setup_sdkman() {
  topic 'Update sdkman'
  if [ ! -e ${HOME}/.sdkman ] ;then
   curl -s 'https://get.sdkman.io' | bash
  fi
  # shellcheck source=../.sdkman/bin/sdkman-init.sh
  source "${HOME}/.sdkman/bin/sdkman-init.sh"
  sdk update
}

install_java() {
  topic "Install Java"
  for jver in $(yaml_array '.sdkman.javaVersions') ;do
    sdk install java $jver
    ln -snf /etc/ssl/certs/java/cacerts ${HOME}/.sdkman/candidates/java/${jver}/lib/security/cacerts
  done
}

install_groovy() {
  topic "Install Groovy"
  for gver in $(yaml_array '.sdkman.groovyVersions') ;do
    sdk install groovy $gver
  done
}

install_codenarc() {
  topic "Install Codenarc"
  mkdir -p ${HOME}/.config/codenarc
  wget -q -O ${HOME}/.config/codenarc/StarterRuleSet-AllRules.groovy https://raw.githubusercontent.com/CodeNarc/CodeNarc/master/docs/StarterRuleSet-AllRules.groovy.txt
}

cleanup_sdk() {
  topic "Cleanup sdkman after update"
  sdk flush metadata
  sdk flush tmp
  sdk flush version
}

install_maven() {
  topic "Instlal maven and gradle"
  local candidates_root curr_ver app_to_remove

  sdk install maven
  sdk install gradle

  topic "Cleanup maven and gradle"
  for app in maven gradle ;do
    candidates_root=${HOME}/.sdkman/candidates/${app}
    curr_ver=$(readlink ${candidates_root}/current)
    app_to_remove=$(ls --color=never ${candidates_root} | grep -Ev "${curr_ver}|current")
    for ver in $app_to_remove ;do
      echo "Remove ${ver}"
      rm -rf ${candidates_root:?}/${ver}
    done
  done
}

update_os() {
  topic 'Update operating system'
  local to_install
  sudo apt clean && sudo apt update -q
  sudo apt upgrade -q -y && sudo apt full-upgrade --allow-downgrades -q -y && sudo apt autoremove -y
}

install_packages() {
  topic "Install packages"

  for pkg_name in $(yaml_array '.systemPackages') ;do
    if ! (dpkg -l | grep -q " ${pkg_name} ") ;then
      to_install="${to_install} ${pkg_name}"
    fi
  done

  if [[ -n $to_install ]] ;then
    sudo apt -q install --allow-downgrades -y $to_install
  fi
}

update_wsl_config() {
  topic "Update WSL config"
  if ! diff ${REPODIR}/wsl.conf /etc/wsl.conf &> /dev/null ;then
    echo 'Update /etc/wsl.conf. WSL reboot required.'
    sudo cp -f ${REPODIR}/wsl.conf /etc/wsl.conf
  fi
}

install_tfenv() {
  topic 'Update tfenv'
  if [ ! -e ${TOOLS_DIR}/tfenv ] ;then
    git clone --depth=1 https://github.com/tfutils/tfenv.git ${TOOLS_DIR}/tfenv
    export PATH=${TOOLS_DIR}/tfenv/bin:$PATH
  else
    git -C ${TOOLS_DIR}/tfenv pull
    # shellcheck source=./bashrc
    source ${HOME}/.bashrc
  fi
  tfenv install $(yaml_value '.terraform.tfenvVersion')
}

install_tgenv() {
  topic 'Update tgenv'
  if [ ! -e ${TOOLS_DIR}/tgenv ] ;then
    git clone https://github.com/sigsegv13/tgenv.git ${TOOLS_DIR}/tgenv
    export PATH=${TOOLS_DIR}/tgenv/bin:$PATH
  else
    git -C ${TOOLS_DIR}/tgenv pull
  fi
  tgenv install $(yaml_value '.terraform.tgenvVersion')
}

install_git_tools() {
  topic 'Update development tools'

  [ ! -e ${HOME}/.bash_completions/ir.sh ] && ir --install-completion bash

  topic 'Login to github'
  gh auth status | grep "Logged in to github" || gh auth refresh -s read:project
  ir config --token "$(gh auth token)"

  for tool in $(yaml_array '.installReleaseTools') ;do
    type ${tool/*\//} &> /dev/null || ir get https://github.com/${tool} -y
  done

  ir upgrade
}

install_helm() {
  topic "Install Helm"
  export HELM_INSTALL_DIR=${HOME}/bin
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

install_lua_lsp() {
  topic "Install Lua LSP"
  local lua_tag lua_path lua_bin

  [ -e ${HOME}/tools/lua-language-server ] && lua_ver="$(lua-language-server --version)" || lua_ver='none'
  lua_tag="$(gh repo view LuaLS/lua-language-server --json latestRelease -q .latestRelease.name)"
  if [ "${lua_ver}" != "${lua_tag}" ] ;then
    lua_path=${HOME}/tools/lua-language-server
    lua_bin=${lua_path}/bin/lua-language-server
    mkdir -p ${HOME}/tools/lua-language-server
    wget -O /tmp/lua-ls.tar.gz https://github.com/LuaLS/lua-language-server/releases/download/${lua_tag}/lua-language-server-${lua_tag}-linux-x64.tar.gz
    tar -xf /tmp/lua-ls.tar.gz -C ${lua_path}
    chmod +x ${lua_bin}
    ln -snf ${lua_bin} ${HOME}/bin/lua-language-server
  else
    echo "lua-language-server already at latest version ${lua_ver}"
  fi

  type az &>/dev/null || curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
}

setup_permissions() {
  topic "Setup required permissions"
  groups | rg -q docker || sudo usermod -aG docker "$(whoami)"
}

dependencies

case $INSTALL_TYPE in
  all)
    update_os
    install_packages
    update_wsl_config
    setup_dotfiles
    setup_pyenv
    install_python
    update_pip
    install_ansible_galaxy
    python_cleanup
    setup_rvm
    install_rubies
    rvm_cleanup
    install_puppet_lsp
    setup_sdkman
    install_java
    install_groovy
    install_codenarc
    install_maven
    cleanup_sdk
    setup_node
    nodejs_cleanup
    install_tgenv
    install_tfenv
    install_git_tools
    install_helm
    install_lua_lsp
    install_neovim
    install_neovim_plugins
  ;;
  system)
    update_os
    install_packages
    update_wsl_config
  ;;
  tools)
    install_git_tools
    install_helm
    install_lua_lsp
  ;;
  dotfiles)
    setup_dotfiles
  ;;
  ruby)
    setup_rvm
    install_rubies
    rvm_cleanup
    install_puppet_lsp
  ;;
  python)
    setup_pyenv
    install_python
    update_pip
    install_ansible_galaxy
    python_cleanup
  ;;
  sdk)
    setup_sdkman
    install_java
    install_groovy
    install_codenarc
    install_maven
    cleanup_sdk
  ;;
  nodejs)
    setup_node
    nodejs_cleanup
  ;;
  neovim)
    install_neovim
    install_neovim_plugins
  ;;
  tfsuite)
    install_tgenv
    install_tfenv
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
