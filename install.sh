#!/bin/bash
# shellcheck extended-analysis=false

set -e
[ "${@: -1}" == "debug" ] && set -x

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
  dep_pkgs=(curl wget apt-transport-https build-essential jq yq gpg ripgrep fd-find)
  for pkg in "${dep_pkgs[@]}" ;do
    dpkg -l | grep -q " ${pkg} " || sudo apt install -qu ${pkg}
  done
}

hashicorp_repo() {
  if [ ! -e /usr/share/keyrings/hashicorp-archive-keyring.gpg ] ;then
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
  fi
  if [ ! -e /etc/apt/sources.list.d/hashicorp.list ] ;then
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com bookworm main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  fi
}

setup_dotfiles() {
  topic 'Setup dotfiles'

  for mdir in $(yaml_array '.dotfiles.dirs') ;do
    mkdir -p ${mdir}
  done

  for mlink in $(yaml_keys '.dotfiles.links') ;do
    ln -snf ${REPODIR}/${mlink} ${HOME}/$(yaml_value ".dotfiles.links[\"${mlink}\"]")
  done

  if ! rg -q 'dotfiles' ${HOME}/.bashrc ;then
   echo '# Laod dotfiles setup' >> ${HOME}/.bashrc
   # shellcheck disable=SC2016
   echo 'source ${HOME}/dotfiles/bashrc' >> ${HOME}/.bashrc
  fi

  # shellcheck disable=SC2016
  [ ! -e ${HOME}/.bash_profile ] && echo '[ -s "$HOME/.profile" ] && source "$HOME/.profile"' > ${HOME}/.bash_profile

  echo 'Load ~/.bashrc'
  # shellcheck source=./bashrc
  source ${HOME}/.bashrc
}

install_neovim() {
  topic 'Update neovim'
  local url appfile

  url=https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  appfile=${TOOLS_DIR}/nvim.appimage

  wget -O ${appfile} ${url}
  # shellcheck disable=SC2046
  [ $(wc -l ${appfile} | cut -d" " -f1) -eq 0 ] && echo "Failed to download ${url}" && exit 1

  chmod u+x ${appfile}
  ${appfile} --version
  ln -snf ${appfile} ${HOME}/bin/nvim
}

setup_node() {
  topic 'Update nodejs'
  local node_path

  if [ ! -e ${HOME}/.nvm ] ; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$(yaml_value '.nvm.version')/install.sh | bash
  fi

  # shellcheck source=../.nvm/nvm.sh
  source "${HOME}/.nvm/nvm.sh"

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
  node_to_remove=$(ls --color=never $node_path | rg -v "$(node --version)")
  for n in $node_to_remove ;do
    echo "Remove ${n}"
    rm -rf ${node_path:?}/${n}
  done
}

setup_pyenv() {
  topic 'Update pyenv'

  export PYTHON_CONFIGURE_OPTS="--enable-shared"

  [ ! -e ${HOME}/.pyenv ] && curl -fsSL https://pyenv.run | bash

  if ! type pyenv &> /dev/null ;then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
  fi

  pyenv update
}

install_python() {
  topic 'Install python'
  local pydefault

  if ! type pyenv &> /dev/null ;then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
  fi

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
  pip install --upgrade pip
  pip install -r ${REPODIR}/Pythonfile --upgrade
  type gita &> /dev/null && wget -O ${HOME}/.bash_completion.d/gita_completion https://github.com/nosarthur/gita/blob/master/auto-completion/bash/.gita-completion.bash
}

install_ansible_galaxy() {
  ansible-galaxy collection install community.general
}

python_cleanup() {
  topic "Cleanup python after update"
  pip cache purge
}

setup_rvm() {
  topic 'Update rvm'
  if [ ! -e ${HOME}/.rvm ] ;then
    gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
  fi

  type rvm &> /dev/null || export PATH="$PATH:$HOME/.rvm/bin"

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
  local rbver

  type rvm &> /dev/null || export PATH="$PATH:$HOME/.rvm/bin"
  source "${HOME}/.rvm/scripts/rvm"

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
  all_rubies="${rbver} $(yaml_value '.rvm.extraRubiesVersions | join(" ")') default"
  for rb in ${HOME}/.rvm/rubies/* ;do
    base_ruby=$(basename $rb | sed 's/ruby-//g')
    if [[ "${all_rubies}" != *${base_ruby}* ]] ;then
      echo "Remove ${rb}"
      rm -rf ${rubies_path:?}/${rb}
    fi
  done
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
  wget -O ${HOME}/.config/codenarc/StarterRuleSet-AllRules.groovy https://raw.githubusercontent.com/CodeNarc/CodeNarc/master/docs/StarterRuleSet-AllRules.groovy.txt
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
    for ver in ${candidates_root}/* ;do
      base_sdk=$(basename $ver)
      if [[ "${curr_ver} current" != *${base_sdk}* ]] ;then
        echo "Remove ${ver}"
        rm -rf ${ver}
      fi
    done
  done
}

update_os() {
  topic 'Update operating system'
  sudo apt clean && sudo apt update -q
  sudo apt upgrade -q -y && sudo apt full-upgrade --allow-downgrades -q -y && sudo apt autoremove -y
}

install_packages() {
  topic "Install packages"
  local to_install

  for pkg_name in $(yaml_array '.systemPackages') ;do
    if ! (dpkg -l | rg -q " ${pkg_name} ") ;then
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
  else
    git -C ${TOOLS_DIR}/tfenv reset --hard
    git -C ${TOOLS_DIR}/tfenv pull
  fi
  type tfenv &> /dev/null || export PATH=$HOME/tools/tfenv/bin:$PATH
  for ver in $(yaml_array '.terraform.tfenvVersion') ;do
    tfenv install $ver
  done
  tfenv use $(yaml_array '.terraform.tfenvVersion' | cut -d' ' -f1)
}

install_tgenv() {
  topic 'Update tgenv'
  if [ ! -e ${TOOLS_DIR}/tgenv ] ;then
    git clone https://github.com/tgenv/tgenv.git ${TOOLS_DIR}/tgenv
  else
    git -C ${TOOLS_DIR}/tgenv reset --hard
    git -C ${TOOLS_DIR}/tgenv pull
  fi
  type tgenv &> /dev/null || export PATH=${TOOLS_DIR}/tgenv/bin:$PATH
  for ver in $(yaml_array '.terraform.tgenvVersion') ;do
    tgenv install $ver
  done
  tfenv use $(yaml_array '.terraform.tgenvVersion' | cut -d' ' -f1)
}

install_git_tools() {
  topic 'Update development tools'

  [ ! -e ${HOME}/.bash_completions/ir.sh ] && ir --install-completion bash

  topic 'Login to github'
  gh auth status | rg "You are not logged into any GitHub hosts" && gh auth login -h github.com -p ssh -s read:project
  ir config --token "$(gh auth token)"

  for tool in $(yaml_array '.installReleaseTools') ;do
    type ${tool/*\//} &> /dev/null || ir get https://github.com/${tool} -y
  done

  ir upgrade -y
}

install_helm() {
  topic "Install Helm"
  export HELM_INSTALL_DIR=${HOME}/bin
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

setup_permissions() {
  topic "Setup required permissions"
  groups | rg -q docker || sudo usermod -aG docker "$(whoami)"
}

dependencies

case $INSTALL_TYPE in
  all)
    update_os
    hashicorp_repo
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
    install_neovim
  ;;
  system)
    hashicorp_repo
    update_os
    install_packages
    update_wsl_config
  ;;
  tools)
    install_git_tools
    install_helm
  ;;
  dotfiles)
    setup_dotfiles
  ;;
  ruby)
    setup_rvm
    install_rubies
    rvm_cleanup
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
