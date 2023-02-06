#!/bin/bash

cd ${HOME}/ || (echo "$(tput setaf 1) Failed to enter ${HOME}" && exit)
CONF=$(dirname "$(readlink -f $0)")

topic() {
  echo "$(tput bold)$(tput setaf 4)${1}$(tput sgr0)"
}

task() {
  echo "$(tput setaf 2)${1}$(tput sgr0)"
}

git_data() {
  GIT_API="$(curl --no-progress-meter ${1})"
  APP_VERSION=$(echo "${GIT_API}" |grep "tag_name" |sed -r 's/.*([0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2})",/\1/g')
  APP_URL=$(echo "${GIT_API}" |grep -E "Linux-x86_64|Linux_amd64|linux-x64" | grep "download" |sed 's/.*\(https.*\)"/\1/g')
}

topic 'INSTALL DEPENDENCIES'

DEP_PKG_LIST=(curl wget apt-transport-https)
for pkg in "${DEP_PKG_LIST[@]}" ;do
  dpkg -l | grep -q " ${pkg} " || sudo apt install -qu ${pkg}
done

if ! (apt-cache policy | grep -q puppet-tools) ;then
  wget -q -O /tmp/puppet-tools-release.deb https://apt.puppet.com/puppet-tools-release-bullseye.deb
  sudo dpkg -i /tmp/puppet-tools-release.deb
fi

if ! (apt-cache policy | grep -q helm) ;then
  echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-debian.list
  curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
fi

if ! (apt-cache policy | grep -q hashicorp) ;then
  wget -q -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi

topic 'UPDATE OPERATING SYSTEM'

sudo apt update -q

TO_INSTALL=''
while read -r line ;do
  if ! (dpkg -l | grep -q " ${line} ") ;then
    TO_INSTALL="${TO_INSTALL} ${line}"
  fi
done < ${HOME}/Rpmfile

if [ "${TO_INSTALL}" != '' ] ;then
  sudo apt -q install -y $TO_INSTALL
fi

sudo apt upgrade -q -y && sudo apt autoremove -y

topic 'SETUP DOTFILES'

MAKE_DIRS=(
  "${HOME}/.config/nvim/undo"
  "${HOME}/.config/nvim/tmp"
  "${HOME}/tools"
)
for mdir in "${MAKE_DIRS[@]}" ;do
  mkdir -p ${mdir}
done

declare -A MAKE_LINKS=(
  ["bash.d"]=".bash.d"
  ["inputrc"]=".inputrc"
  ["bin"]="bin"
  ["nvim/init.lua"]=".config/nvim/init.lua"
  ["nvim/autoload"]=".config/nvim/autoload"
  ["nvim/colors"]=".config/nvim/colors"
  ["nvim/minisnip"]=".config/nvim/minisnip"
  ["nvim/scripts"]=".config/nvim/scripts"
  ["nvim/spell"]=".config/nvim/spell"
  ["nvim/lua"]=".config/nvim/lua"
  ["mdlrc"]=".mdlrc"
  ["mdl_style.rb"]=".mdl_style.rb"
  ["shellcheckrc"]=".shellcheckrc"
  ["ctags.d"]=".ctags.d"
  ["gitattributes"]=".gitattributes"
  ["gitconfig"]=".gitconfig"
  ["irbrc"]=".irbrc"
  ["rvmrc"]=".rvmrc"
  ["puppet-lint.rc"]=".puppet-lint.rc"
  ["reek"]=".reek"
  ["rubocop.yaml"]=".rubocop.yaml"
  ["soloargraph.yml"]=".soloargraph.yml"
  ["screenrc"]=".screenrc"
  ["tmux.conf"]=".tmux.conf"
  ["vintrc.yaml"]=".vintrc.yaml"
  ["codenarc"]=".codenarc"
  ["yamllint"]=".yamllint"
  ["pylintrc"]=".pylintrc"
  ["Pythonfile"]="Pythonfile"
  ["package.json"]="package.json"
  ["Gemfile"]="Gemfile"
  ["Rpmfile"]="Rpmfile"
)
for mlink in "${!MAKE_LINKS[@]}" ;do
  ln -snf ${CONF}/${mlink} ${HOME}/${MAKE_LINKS["${mlink}"]}
done

if ! (grep -q '\.bash\.d' ${HOME}/.profile) ;then
 echo '# Laod custom dotfiles' >> ${HOME}/.profile
 echo 'for i in ${HOME}/bash.d/* ;do source ${i} ;done' >> ${HOME}/.profile
fi

topic 'UPDATE NEOVIM'

NVIM_PKG=/tmp/nvim-linux64.deb
NVIM_SHA=/tmp/nvim-linux64.deb.sha256sum
wget -q -O ${NVIM_SHA} https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb.sha256sum
if [ ! -e ${NVIM_PKG} ] || [ "$(cut -d " " -f1 < /tmp/nvim-linux64.deb.sha256sum)" != "$(sha256sum ${NVIM_PKG} |cut -d " " -f1)" ] ;then
 wget -q -O ${NVIM_PKG} https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb
 sudo dpkg -i ${NVIM_PKG}
fi

PACKERPATH=~/.local/share/nvim/site/pack/packer/start
if [ ! -e ${PACKERPATH}/packer.nvim ] ;then
 mkdir -p ${PACKERPATH}
 git clone --depth 1 https://github.com/wbthomason/packer.nvim ${PACKERPATH}/packer.nvim
fi

task "Update Neovim plugins"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
for i in $(fdfind --type d --exact-depth 2 . ~/.local/share/nvim/site/pack/packer) ; do echo "-> Update $(basename ${i})" && git --git-dir ${i}/.git log --oneline @{1}..origin ;done

task "Update Neovim treesitter"
nvim --headless -c 'TSUpdateSync | quitall'

echo ""
topic 'UPDATE RUBY'

if [ ! -e ${HOME}/.rvm ] ;then
 curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
 curl -sSL https://get.rvm.io | bash -s stable --version 2.4.10
 source '/home/pbugala/.rvm/scripts/rvm'
fi

rvm get stable
rvm install 2.7.3 --default
rvm install 2.4.10
gem install bundle
bundle update

topic 'UPDATE PYTHON'

export PYTHON_CONFIGURE_OPTS="--enable-shared"
PYTHON_VERSION=3.8.13
if [ ! -e ${HOME}/.pyenv ] ;then
 export PYENV_GIT_TAG=v${PYTHON_VERSION}
 curl https://pyenv.run | bash
 pyenv install ${PYTHON_VERSION}
 pyenv global ${PYTHON_VERSION}
fi

pyenv update
python -m pip install --upgrade pip
pip install -r ${HOME}/Pythonfile --upgrade
ansible-galaxy collection install community.general

topic 'UPDATE SDKMAN'

if [ ! -e ${HOME}/.sdkman ] ;then
 curl -s 'https://get.sdkman.io' | bash
 source "${HOME}/.sdkman/bin/sdkman-init.sh"
fi

source "${HOME}/.sdkman/bin/sdkman-init.sh"
sdk update
sdk install java 11.0.12-open
sdk install groovy 2.4.12
sdk install maven && sdk install gradle
ln -snf /etc/ssl/certs/java/cacerts ${HOME}/.sdkman/candidates/java/current/lib/security/cacerts

topic 'UPDATE NODEJS'

source "${HOME}/.nvm/nvm.sh"

if [ ! -e ${HOME}/.nvm ] ; then
 curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi

nvm install node
nvm alias default node
nvm use node
npm install
npm update
npm link

topic 'UPDATE CUSTOM TOOLS'

task 'Update hadolint'
HADOLINT_DATA=$(git_data https://api.github.com/repos/hadolint/hadolint/releases/latest)
if ! (hadolint --version | grep -q "$(echo ${HADOLINT_DATA} | cut -d' ' -f1)") ;then
 wget -q -O ${HOME}/bin/hadolint "$(echo ${HADOLINT_DATA} | cut -d' ' -f2)"
 chmod +x ${HOME}/bin/hadolint
fi

task "Update k9s"
K9S_DATA=$(git_data https://api.github.com/repos/derailed/k9s/releases/latest)
if ! (k9s version |grep -q "$(echo ${K9S_DATA} | cut -d' ' -f1)") ;then
 wget -q -O /tmp/k9s.tar.gz "$(echo ${K9S_DATA} | cut -d' ' -f2)"
 tar -xvf /tmp/k9s.tar.gz -C ${HOME}/bin k9s
fi

cd ${HOME}/tools || (echo "$(tput setaf 1)Failed to enter ${HOME}/tools" && exit)

task "Update Lua Language Server"
LUA_LSP_DATA=$(git_data https://api.github.com/repos/sumneko/lua-language-server/releases/latest)
LUA_LSP_DIR=${HOME}/tools/lua-language-server
if ! (${LUA_LSP_DIR}/bin/luals.sh --version | grep -q "$(echo ${LUA_LSP_DATA} | cut -d' ' -f1)") ;then
 mkdir -p $LUA_LSP_DIR
 wget -q -O /tmp/luals.tar.gz "$(echo ${LUA_LSP_DATA} | cut -d' ' -f2)"
 tar -xf /tmp/luals.tar.gz -C $LUA_LSP_DIR
 echo "exec \"${LUA_LSP_DIR}/bin/lua-language-server\" \"\$@\"" > ${LUA_LSP_DIR}/bin/luals.sh
 chmod +x ${LUA_LSP_DIR}/bin/luals.sh
fi

task "Update Groovy Language Server"
GROOVY_LSP_DIR=${HOME}/tools/groovy-language-server
if [ ! -e $GROOVY_LSP_DIR ] ;then git clone https://github.com/GroovyLanguageServer/groovy-language-server.git ;fi
cd $GROOVY_LSP_DIR || (echo "Failed to enter ${GROOVY_LSP_DIR}" && exit)
if test ! -d build || git remote show origin | grep -q 'out of date' ;then
 git pull
 ./gradlew clean build -x test
fi
cd ${HOME}/tools || (echo "Failed to enter ${HOME}/tools" && exit)

task "Update Puppet Language Server"
PUPPET_LSP_DIR=${HOME}/tools/puppet-editor-services
if [ ! -e $PUPPET_LSP_DIR ] ;then git clone https://github.com/puppetlabs/puppet-editor-services.git ;fi
cd $PUPPET_LSP_DIR || (echo "Failed to enter ${PUPPET_LSP_DIR}" && exit)
if test ! -f Gemfile.lock || git remote show origin | grep -q "out of date" ;then
 git pull
 bundle install
fi
cd ${HOME}/tools || (echo "Failed to enter ${HOME}/tools" && exit)

task "Puppet Treesitter setup"
PUPPET_TS_DIR=${HOME}/tools/tree-sitter-puppet
PUPPET_Q_DIR=${HOME}/.local/share/nvim/site/pack/packer/start/nvim-treesitter/queries/puppet
if [ ! -e $PUPPET_TS_DIR ] ;then git clone https://github.com/neovim-puppet/tree-sitter-puppet.git ;fi
cd $PUPPET_TS_DIR || (echo "Failed to enter ${PUPPET_TS_DIR}" && exit)
git pull
if [ ! -e $PUPPET_Q_DIR ] ;then mkdir -p $PUPPET_Q_DIR ;fi
cp ${PUPPET_TS_DIR}/queries/* ${PUPPET_Q_DIR}/
cd ${HOME}/tools || (echo "Failed to enter ${HOME}/tools" && exit)

topic 'SETUP WINDOWS TOOLS CONFIGURATION'
cp ${CONF}/viebrc /mnt/c/Users/${USER}/.viebrc
cp ${CONF}/wezterm.lua /mnt/c/Users/${USER}/.wezterm.lua
