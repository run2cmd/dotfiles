#!/bin/bash
# shellcheck extended-analysis=false

set -e

REPODIR=$(dirname "$(readlink -f "${0}")")

topic() {
  echo "$(tput bold)$(tput setaf 4)${1}$(tput sgr0)"
}

dependencies() {
  topic 'Install dependencies'
  sudo ln -snf "${REPODIR}/install.sh" "/usr/local/bin/dotfiles-update"
  sudo pacman -S --noconfirm --needed wget curl
}

setup_dotfiles_dirs() {
  topic 'Setup dotfiles directories'
  local create_dirs

  create_dirs=(
    "${HOME}/.config/nvim/undo"
    "${HOME}/.config/nvim/tmp"
    "${HOME}/.bash_completion.d"
    "${HOME}/.tmux/plugins/tpm"
    "${HOME}/.tmux/sessions"
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
    "gitexclude .gitignore"
    "bash_completion .bash_completion.d/bash_completion"
    "tmux_start.sh .tmux/sessions/tmux_start.sh"
  )

  for mlink in "${create_links[@]}" ;do
    ln -snf "${REPODIR}/${mlink// */}" "${HOME}/${mlink//* /}"
  done
}

setup_dotfiles_bash() {
  topic 'Setup dotfiles bash configuration'

  if ! grep -q 'dotfiles' ~/.bashrc ;then
   echo '# Laod dotfiles setup' >> ~/.bashrc
   # shellcheck disable=SC2016
   echo 'source /code/dotfiles/bashrc' >> ~/.bashrc
  fi

  echo 'Load ~/.bashrc'
  # shellcheck disable=SC1090
  source ~/.bashrc
}

setup_dotfiles_ahk() {
  topic 'Setup Windows autohotkey startup files'
  local startup_dir

  startup_dir=$(wslpath "$(cmd.exe /C "echo %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" 2>/dev/null | tr -d '\r')")

  cp "${REPODIR}/autohotkey"/* "${startup_dir}"
}

setup_gita() {
  topic 'Setup gita'
  sudo pipx install gita --global
  if ! grep -q gita_completion ~/.bashrc ;then
    wget -O ~/.bash_completion.d/gita_completion https://raw.githubusercontent.com/nosarthur/gita/refs/heads/master/auto-completion/bash/.gita-completion.bash
    {
      echo ''
      echo 'source ~/.bash_completion.d/gita_completion'
    } >> ~/.bashrc
  fi
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
  if [ ! -e ~/.rvm ] ;then
    gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
  fi

  type rvm &> /dev/null || export PATH="$PATH:$HOME/.rvm/bin"

  # shellcheck disable=SC1090
  source ~/.rvm/scripts/rvm

  rvm get stable
  rvm autolibs enable
  rvm use system --default
}

rvm_cleanup() {
  topic "Cleanup rvm after update"
  local default_ruby
  rvm cleanup all
}

update_os() {
  topic 'Update operating system'
  sudo pacman -Sc --noconfirm && sudo pacman -Syu --noconfirm
}

install_packages() {
  topic "Install packages"
  local sys_packages

  sys_packages=(
    ansible
    augeas
    base-devel
    bat
    bash-completion
    chromium
    cpio
    diffutils
    dos2unix
    dnsutils
    fd
    fuse
    fzf
    gcc
    glibc-locales
    github-cli
    go
    gradle
    groovy
    helm
    jq
    keychain
    kubectl
    lazygit
    libunwind
    llvm
    lua
    make
    man-db
    maven
    neovim
    nodejs
    npm
    openbsd-netcat
    nmap
    pkgconf
    plantuml
    postgresql
    podman
    puppet
    python
    python-pip
    python-pipx
    ripgrep
    rpmextract
    ruby
    ruby-lsp
    sshpass
    tcl
    terraform
    terragrunt
    tk
    tmux
    twine
    tcpdump
    unzip
    which
    xz
    yq
    zip
  )

  # shellcheck disable=SC2068
  sudo pacman -S --noconfirm --needed ${sys_packages[@]}

  # Podman fix on arch
  sudo chmod u+s /usr/bin/newuidmap /usr/bin/newgidmap
}

update_wsl_config() {
  topic "Update WSL config"

  if ! diff "${REPODIR}/wsl.conf" /etc/wsl.conf &> /dev/null ;then
    echo 'Update /etc/wsl.conf. WSL reboot required.'
    sudo cp -f "${REPODIR}/wsl.conf" /etc/wsl.conf
  fi
}

tmux_plugins_update() {
  if [ ! -e  ~/.tmux/plugins/tpm ] ;then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  else
    git -C ~/.tmux/plugins/tpm pull
  fi
}

tmux_sessions() {
  local session_file
  session_file=~/.tmux/sessions/start.sh
  [ ! -e "${session_file}" ] && touch "${session_file}"
}

github_copilot() {
  topic "Install GitHub Copilot CLI"
  curl -fsSL https://gh.io/copilot-install | sudo bash
}

run_system() {
  update_os
  install_packages
  update_wsl_config
}

run_dotfiles() {
  setup_dotfiles_dirs
  setup_dotfiles_links
  setup_dotfiles_bash
  setup_dotfiles_ahk
}

run_cleanup() {
  rvm_cleanup
  python_cleanup
}

run_tmux_plugins() {
  tmux_plugins_update
}

run_tools() {
  setup_rvm
  setup_gita
  install_ansible_galaxy
  github_copilot
}

dependencies

case $1 in
  all)
    run_system
    run_dotfiles
    run_tmux_plugins
    run_tools
  ;;
  system) run_system ;;
  dotfiles) run_dotfiles ;;
  tmux) run_tmux_plugins ;;
  cleanup) run_cleanup ;;
  tools) run_tools ;;
  *)
    echo "
    Usage: dotfiles-update [INSTALL_TYPE]
    Installation types available:
      all - Run complex installation/update of everything. If this is 1st installtion you need to choose this option.
      system - System OS update.
      dotfiles - Install dotfiles.
      tmux - Update Tmux Plugin Manager.
      cleanup - Clean up old tools not managed by dotfiles configuration.
      tools - Install additional tools like GitHub Copilot CLI, RVM, etc.
    "
  ;;
esac
