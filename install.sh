#!/bin/bash
# shellcheck extended-analysis=false

set -e

REPODIR=$(dirname "$(readlink -f "${0}")")
TOOLS_DIR=/usr/local/bin
INSTALL_TYPE=$1

sudo ln -snf "${REPODIR}/install.sh" "${TOOLS_DIR}/dotfiles-update"

topic() {
  echo "$(tput bold)$(tput setaf 4)${1}$(tput sgr0)"
}

dependencies() {
  topic 'Install dependencies'
  local dep_pkgs
  dep_pkgs=(curl wget apt-transport-https build-essential gpg)
  for pkg in "${dep_pkgs[@]}" ;do
    dpkg -l | grep -q " ${pkg} " || sudo apt install -yqu "${pkg}"
  done
}

setup_dotfiles_dirs() {
  topic 'Setup dotfiles directories'
  local create_dirs

  create_dirs=(
    "${HOME}/.config/nvim/undo"
    "${HOME}/.config/nvim/tmp"
    "${HOME}/.bash_completion.d"
    "${HOME}/.tmux/scripts"
  )

  for dir in "${create_dirs[@]}" ;do
    mkdir -p "${dir}"
  done
}

setup_dotfiles_links() {
  topic 'Setup dotfiles links'
  local create_links

  create_links=(
    "nvim/init.lua .config/nvim/init.lua"
    "nvim/syntax .config/nvim/syntax"
    "nvim/scripts .config/nvim/scripts"
    "nvim/spell .config/nvim/spell"
    "nvim/lua .config/nvim/lua"
    "gitattributes .gitattributes"
    "gitconfig .gitconfig"
    "tmux.conf .tmux.conf"
    "tmux/switch_session_window.sh .tmux/scripts/switch_session_window.sh"
    "gitexclude .gitignore"
    "bash_completion .bash_completion.d/bash_completion"
  )

  for mlink in "${create_links[@]}" ;do
    ln -snf "${REPODIR}/${mlink// */}" "${HOME}/${mlink//* /}"
  done
}

setup_dotfiles_bash() {
  topic 'Setup dotfiles bash configuration'

  if ! grep -q 'dotfiles' "${HOME}/.bashrc" ;then
   echo '# Laod dotfiles setup' >> "${HOME}/.bashrc"
   # shellcheck disable=SC2016
   echo 'source /code/dotfiles/bashrc' >> "${HOME}/.bashrc"
  fi

  # shellcheck disable=SC2016
  [ ! -e "${HOME}/.bash_profile" ] && echo '[ -s "$HOME/.profile" ] && source "$HOME/.profile"' > "${HOME}/.bash_profile"

  echo 'Load ~/.bashrc'
  # shellcheck disable=SC1091
  source "${HOME}/.bashrc"
}

setup_dotfiles_ahk() {
  topic 'Setup Windows autohotkey startup files'
  local startup_dir

  startup_dir=$(wslpath "$(cmd.exe /C "echo %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" 2>/dev/null | tr -d '\r')")

  cp "${REPODIR}/autohotkey"/* "${startup_dir}"
}

install_neovim() {
  topic 'Update neovim'
  sudo apt install -yu binutils-dev libunwind8 neovim
  nvim --version
}

setup_node() {
  topic 'Update nodejs'
  local nvm_version

  nvm_version="v0.40.3"

  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh" | bash

  # shellcheck disable=SC1091
  source "${HOME}/.nvm/nvm.sh"

  nvm install node
  nvm alias default node
  nvm use node
  npm install -g tree-sitter-cli @devcontainers/cli
  npm update
}

nodejs_cleanup() {
  topic "Cleanup nodejs after update"
  nvm cache clear
  for n in "${HOME}"/.nvm/versions/node/* ;do
    if [[ "${n}" != *$(node --version)* ]] ;then
      echo "Remove ${n}"
      rm -rf "${n}"
    fi
  done
}

setup_pyenv() {
  topic 'Update pyenv'

  export PYTHON_CONFIGURE_OPTS="--enable-shared"

  [ ! -e "${HOME}/.pyenv" ] && curl -fsSL https://pyenv.run | bash

  if ! type pyenv &> /dev/null ;then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
  fi

  pyenv update
}

install_python() {
  topic 'Install python'
  local pydefault

  pydefault=3

  if ! type pyenv &> /dev/null ;then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
  fi

  pyenv install -s "${pydefault}"

  export CPPFLAGS="-I/usr/include/openssl"
  export LDFLAGS="-L/usr/lib/x86_64-linux-gnu"
  pyenv global "${pydefault}"
  cd ~/.pyenv && src/configure && make -C src
}

update_pip() {
  topic 'Update Python packages'
  pip install --upgrade pip
  pip install ansible twine wheel gita
  type gita &> /dev/null && wget -O "${HOME}/.bash_completion.d/gita_completion" https://github.com/nosarthur/gita/blob/master/auto-completion/bash/.gita-completion.bash
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
  if [ ! -e "${HOME}/.rvm" ] ;then
    gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
  fi

  type rvm &> /dev/null || export PATH="$PATH:$HOME/.rvm/bin"

  # shellcheck disable=SC1091
  source "${HOME}/.rvm/scripts/rvm"

  rvm get stable
  rvm autolibs enable
}

install_rubies() {
  topic 'Install rubies'
  local rbver

  type rvm &> /dev/null || export PATH="$PATH:$HOME/.rvm/bin"

  # shellcheck disable=SC1091
  source "${HOME}/.rvm/scripts/rvm"

  rbver=3.4.7

  rvm install "${rbver}" --default
  rvm docs generate-ri "${rbver}"
  rvm docs generate-gems "${rbver}"

  topic "Update default ruby"
  rvm use "${rbver}"
  gem update --system
  gem install bundle puppet ruby-lsp
}

rvm_cleanup() {
  topic "Cleanup rvm after update"
  local default_ruby

  default_ruby="$(rvm list default string)"

  rvm cleanup all

  for rb in "${HOME}"/.rvm/rubies/* ;do
    if [[ "${rb}" != *${default_ruby}* ]] && [[ "${rb}" != *default* ]]  ;then
      echo "Remove ${rb}"
      rm -rf "${rb}"
    fi
  done
}

setup_sdkman() {
  topic 'Update sdkman'

  if [ ! -e "${HOME}/.sdkman" ] ;then
   curl -s 'https://get.sdkman.io' | bash
  fi

  # shellcheck disable=SC1091
  source "${HOME}/.sdkman/bin/sdkman-init.sh"
  sdk update
}

install_java() {
  topic "Install Java"
  jver="21.0.7-tem"
  sdk install java "${jver}"
  ln -snf /etc/ssl/certs/java/cacerts "${HOME}/.sdkman/candidates/java/${jver}/lib/security/cacerts"
}

install_groovy() {
  topic "Install Groovy"
  sdk install groovy 2.4.21
}

install_codenarc() {
  topic "Install Codenarc"
  mkdir -p "${HOME}/.config/codenarc"
  wget -O "${HOME}/.config/codenarc/StarterRuleSet-AllRules.groovy" https://raw.githubusercontent.com/CodeNarc/CodeNarc/master/docs/StarterRuleSet-AllRules.groovy.txt
}

cleanup_sdk() {
  topic "Cleanup sdkman after update"
  sdk flush metadata
  sdk flush tmp
  sdk flush version
}

install_maven() {
  topic "Instlal maven and gradle"
  sdk install maven
  sdk install gradle
}

cleanup_maven() {
  topic "Cleanup maven and gradle"

  for app in maven gradle ;do
    candidates_root=${HOME}/.sdkman/candidates/${app}
    curr_ver=$(readlink "${candidates_root}/current")
    for ver in "${candidates_root}"/* ;do
      base_sdk=$(basename "${ver}")
      if [[ "${curr_ver} current" != *${base_sdk}* ]] ;then
        echo "Remove ${ver}"
        rm -rf "${ver}"
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
  local to_install sys_packages

  sys_packages=(
    augeas-tools
    bat
    bash-completion
    chromium
    cpio
    colorized-logs
    dos2unix
    dnsutils
    fd-find
    fuse
    fzf
    git
    gh
    golang
    jq
    keychain
    lazygit
    llvm
    lua5.3
    make
    man-db
    ncat
    nmap
    openssh-client
    plantuml
    postgresql
    podman
    ripgrep
    rpm
    rpm2cpio
    sshpass
    tmux
    tcpdump
    unzip
    xz-utils
    yq
    zip
  )

  for pkg_name in "${sys_packages[@]}" ;do
    if ! (dpkg -l | grep -q " ${pkg_name} ") ;then
      to_install="${to_install} ${pkg_name}"
    fi
  done

  if [[ -n $to_install ]] ;then
   # shellcheck disable=SC2086
    sudo apt -q install --allow-downgrades -y $to_install
  fi
}

update_wsl_config() {
  topic "Update WSL config"

  if ! diff "${REPODIR}/wsl.conf" /etc/wsl.conf &> /dev/null ;then
    echo 'Update /etc/wsl.conf. WSL reboot required.'
    sudo cp -f "${REPODIR}/wsl.conf" /etc/wsl.conf
  fi
}

install_tfenv() {
  topic 'Update tfenv'

  mkdir -p "${HOME}/tools"

  if [ ! -e "${HOME}/tools/tfenv" ] ;then
    git clone --depth=1 https://github.com/tfutils/tfenv.git "${HOME}/tools/tfenv"
  else
    git -C "${HOME}/tools/tfenv" reset --hard
    git -C "${HOME}/tools/tfenv" pull
  fi

  type tfenv &> /dev/null || export PATH=${HOME}/tools/tfenv/bin:$PATH
  tfenv install latest
  tfenv use latest
}

install_tgenv() {
  topic 'Update tgenv'

  mkdir -p "${HOME}/tools"

  if [ ! -e "${HOME}/tools/tgenv" ] ;then
    git clone https://github.com/tgenv/tgenv.git "${HOME}/tools/tgenv"
  else
    git -C "${HOME}/tools/tgenv" reset --hard
    git -C "${HOME}/tools/tgenv" pull
  fi

  type tgenv &> /dev/null || export PATH=${HOME}/tools/tgenv/bin:$PATH
  tgenv install latest
  tgenv use latest
}

install_helm() {
  topic "Install Helm"
  export HELM_INSTALL_DIR="${TOOLS_DIR}"
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

run_system() {
  update_os
  install_packages
  update_wsl_config
}

run_tools() {
  install_helm
}

run_dotfiles() {
  setup_dotfiles_dirs
  setup_dotfiles_links
  setup_dotfiles_bash
  setup_dotfiles_ahk
}

run_ruby() {
  setup_rvm
  install_rubies
}

run_python() {
  setup_pyenv
  install_python
  update_pip
  install_ansible_galaxy
}

run_sdk() {
  setup_sdkman
  install_java
  install_groovy
  install_codenarc
  install_maven
}

run_node() {
  setup_node
}

run_tf() {
  install_tgenv
  install_tfenv
}

run_nvim() {
  install_neovim
}

run_cleanup() {
  rvm_cleanup
  python_cleanup
  cleanup_sdk
  nodejs_cleanup
  cleanup_maven
}

dependencies

case $INSTALL_TYPE in
  all)
    run_system
    run_dotfiles
    run_tools
    run_ruby
    run_python
    run_sdk
    run_node
    run_nvim
    run_tf
  ;;
  system) run_system ;;
  tools) run_tools ;;
  dotfiles) run_dotfiles ;;
  ruby) run_ruby ;;
  python) run_python ;;
  sdk) run_sdk ;;
  nodejs) run_node ;;
  neovim) run_nvim ;;
  tfsuite) run_tf ;;
  cleanup) run_cleanup ;;
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
      cleanup - Clean up old tools not managed by dotfiles configuration.
    "
  ;;
esac
