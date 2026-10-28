#!/bin/bash
# shellcheck extended-analysis=false

set -e

REPODIR=$(dirname "$(readlink -f "${0}")")

topic() {
  echo "$(tput bold)$(tput setaf 4)${1}$(tput sgr0)"
}

dependencies() {
  topic 'Install dependencies'
  if [ ! -e "/usr/local/bin/dotfiles-update" ] ;then
    sudo ln -snf "${REPODIR}/install.sh" "/usr/local/bin/dotfiles-update"
    echo 'Tool dotfiles-update installed. Run "dotfiles-update" to setup environment.'
  fi
  sudo pacman -S --noconfirm --needed wget curl
}

setup_dotfiles_dirs() {
  topic 'Setup dotfiles directories'
  local create_dirs

  create_dirs=(
    "${HOME}/.config/nvim/undo"
    "${HOME}/.config/nvim/tmp"
    "${HOME}/.config/nvim/after/syntax"
    "${HOME}/.bash_completion.d"
    "${HOME}/.tmux/plugins/tpm"
    "${HOME}/.tmux/sessions"
    "${HOME}/.ctags.d"
    "${HOME}/.local/share/nvim/tags"
    "${HOME}/bin"
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
    "nvim/after/syntax/sh.vim .config/nvim/after/syntax/sh.vim"
    "nvim/scripts .config/nvim/scripts"
    "nvim/spell .config/nvim/spell"
    "nvim/lua .config/nvim/lua"
    "nvim/ctags/custom.ctags .ctags.d/custom.ctags"
    "nvim/groovylint/.groovylintrc.json .groovylintrc.json"
    "gitattributes .gitattributes"
    "gitconfig .gitconfig"
    "tmux.conf .tmux.conf"
    "gitexclude .gitignore"
    "bash_completion .bash_completion.d/bash_completion"
    "bin/tmux-copy bin/tmux-copy"
    "bin/tmux-session-switch bin/tmux-session-switch"
    "bin/tmux-project bin/tmux-project"
    "bin/java21 bin/java21"
    "bin/mvn3jdk21 bin/mvn3jdk21"
    "bin/ruby32 bin/ruby32"
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
  if type gita &> /dev/null ;then
    sudo pipx upgrade gita --global
  else
    sudo pipx install gita --global
  fi
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

install_gem_tools() {
  topic 'Install gem-based linters'
  gem install --user-install puppet-lint
}

update_os() {
  topic 'Update operating system'
  sudo pacman -Scc --noconfirm && sudo pacman -Syu --noconfirm
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
    ctags
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
    luarocks
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
    sshpass
    tcl
    terraform
    terragrunt
    tidy
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
  if type copilot &> /dev/null ;then
    sudo copilot update
  else
    curl -fsSL https://gh.io/copilot-install | sudo bash
  fi
}

cleanup() {
  topic 'Cleanup'

  sudo pacman -Scc --noconfirm
  sudo journalctl --vacuum-size=50M
  npm cache clean --force
  rm -rf "${HOME}/.npm/_npx" "${HOME}/.gradle"

  # Caches only. Copilot sessions live in ~/.copilot/session-state and are not touched
  find "${HOME}/.cache" -mindepth 1 -maxdepth 1 ! -name copilot -exec rm -rf {} +

  # Keep only the newest Copilot CLI version
  local pkg_dir old_versions version
  for pkg_dir in "${HOME}/.copilot/pkg/linux-x64" "${HOME}/.cache/copilot/pkg/linux-x64" ;do
    [ -d "${pkg_dir}" ] || continue
    old_versions=$(ls -1 "${pkg_dir}" | sort -V | head -n -1)
    for version in ${old_versions} ;do
      rm -rf "${pkg_dir:?}/${version}"
    done
  done

  # Remove only git-ignored files (build output, caches). Non-git dirs are skipped
  local repo
  for repo in /code/*/ ;do
    [ -e "${repo}.git" ] || continue
    git -C "${repo}" clean -fdX
  done

  # Unused images are pulled again by the shims when needed
  podman system prune --all --force
}

vhd_instructions() {
  local vhd_path

  vhd_path=$(powershell.exe -NoProfile -Command "(Get-ChildItem HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Lxss | Where-Object { (Get-ItemProperty \$_.PSPath).DistributionName -eq '${WSL_DISTRO_NAME}' } | Get-ItemProperty).BasePath" 2>/dev/null | tr -d '\r' | sed 's/^\\\\?\\//')
  if [ -n "${vhd_path}" ] ;then
    vhd_path="${vhd_path}\\ext4.vhdx"
  else
    vhd_path='<path to ext4.vhdx, see README>'
  fi

  topic 'Additional steps to complete update: shrink WSL disk'
  cat <<EOT
Deleted files do not shrink the WSL disk. Paste this in elevated PowerShell:

wsl --shutdown; \$s = New-TemporaryFile; Set-Content \$s 'select vdisk file="${vhd_path}"','attach vdisk readonly','compact vdisk','detach vdisk'; diskpart /s \$s; Remove-Item \$s
EOT
}

dependencies

update_os
install_packages
update_wsl_config

setup_dotfiles_dirs
setup_dotfiles_links
setup_dotfiles_bash
setup_dotfiles_ahk

tmux_plugins_update

setup_gita
install_ansible_galaxy
install_gem_tools
github_copilot

cleanup
vhd_instructions
