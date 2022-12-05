#!/bin/bash

cd ${HOME}/ || (echo "Failed to enter ${HOME}" && exit)
CONF=$(dirname "$(readlink -f $0)")

echo '==================================================================================================='
echo 'UPDATE UBUNTU PACKAGES'

dpkg -l | grep -q " curl " || sudo apt install -q -y curl
dpkg -l | grep -q " wget " || sudo apt install -q -y wget
dpkg -l | grep -q " apt-transport-https " || sudo apt install -q -y apt-transport-https

if ! (dpkg -l | grep -q " pdk ") ;then
  wget -q -O /tmp/puppet-tools-release.deb https://apt.puppet.com/puppet-tools-release-bullseye.deb
  sudo dpkg -i /tmp/puppet-tools-release.deb
fi

if [ ! -e /etc/apt/sources.list.d/helm-debian.list ] ;then
  echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-debian.list
  curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
fi

if [ ! -e /etc/apt/sources.list.d/hashicorp.list ] ;then
  wget -q -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi

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

echo '==================================================================================================='
echo 'SETUP DOTFILES'

ln -snf ${CONF}/bash.d ${HOME}/.bash.d
ln -snf ${CONF}/bin ${HOME}/bin

mkdir -p ${HOME}/.config/nvim/undo
mkdir -p ${HOME}/.config/nvim/tmp
ln -snf ${CONF}/nvim/init.lua ${HOME}/.config/nvim/init.lua
ln -snf ${CONF}/nvim/autoload ${HOME}/.config/nvim/autoload
ln -snf ${CONF}/nvim/colors ${HOME}/.config/nvim/colors
ln -snf ${CONF}/nvim/minisnip ${HOME}/.config/nvim/minisnip
ln -snf ${CONF}/nvim/scripts ${HOME}/.config/nvim/scripts
ln -snf ${CONF}/nvim/spell ${HOME}/.config/nvim/spell
ln -snf ${CONF}/nvim/lua ${HOME}/.config/nvim/lua
ln -snf ${CONF}/mdlrc ${HOME}/.mdlrc
ln -snf ${CONF}/shellcheckrc ${HOME}/.shellcheckrc

ln -snf ${CONF}/ctags.d ${HOME}/.ctags.d
ln -snf ${CONF}/gitattributes ${HOME}/.gitattributes
ln -snf ${CONF}/gitconfig ${HOME}/.gitconfig
ln -snf ${CONF}/irbrc ${HOME}/.irbrc
ln -snf ${CONF}/rvmrc ${HOME}/.rvmrc
ln -snf ${CONF}/puppet-lint.rc ${HOME}/.puppet-lint.rc
ln -snf ${CONF}/reek ${HOME}/.reek
ln -snf ${CONF}/rubocop.yaml ${HOME}/.rubocop.yaml
ln -snf ${CONF}/soloargraph.yml ${HOME}/.soloargraph.yml
ln -snf ${CONF}/screenrc ${HOME}/.screenrc
ln -snf ${CONF}/tmux.conf ${HOME}/.tmux.conf
ln -snf ${CONF}/vintrc.yaml ${HOME}/.vintrc.yaml
ln -snf ${CONF}/codenarc ${HOME}/.codenarc
ln -snf ${CONF}/yamllint ${HOME}/.yamllint
ln -snf ${CONF}/pylintrc ${HOME}/.pylintrc

ln -snf ${CONF}/Pythonfile ${HOME}/Pythonfile
ln -snf ${CONF}/package.json ${HOME}/package.json
ln -snf ${CONF}/Gemfile ${HOME}/Gemfile
ln -snf ${CONF}/Rpmfile ${HOME}/Rpmfile

if ! (grep -q '\.bash\.d' ${HOME}/.profile) ;then
  echo '# Laod custom dotfiles' >> ${HOME}/.profile
  echo 'for i in ${HOME}/bash.d/* ;do source ${i} ;done' >> ${HOME}/.profile
fi

echo '==================================================================================================='
echo 'UPDATE NEOVIM'

wget -q -O /tmp/nvim-linux64.deb.sha256sum https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb.sha256sum
if [ ! -e /tmp/nvim-linux64.deb ] || [ "$(cut -d " " -f1 < /tmp/nvim-linux64.deb.sha256sum)" != "$(sha256sum /tmp/nvim-linux64.deb |cut -d " " -f1)" ] ;then
  wget -q -O /tmp/nvim-linux64.deb https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb
  sudo dpkg -i /tmp/nvim-linux64.deb
fi

PACKERPATH=~/.local/share/nvim/site/pack/packer/start
if [ ! -e ${PACKERPATH}/packer.nvim ] ;then
  mkdir -p ${PACKERPATH}
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ${PACKERPATH}/packer.nvim
fi

echo "Update Neovim plugins"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "Update Neovim treesitter"
nvim --headless -c 'TSUpdateSync | quitall'

echo '==================================================================================================='
echo 'UPDATE RUBY'

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

echo '==================================================================================================='
echo 'UPDATE PYTHON'

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

echo '==================================================================================================='
echo 'UPDATE SDKMAN'

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

echo '==================================================================================================='
echo 'UPDATE NODEJS'

source "${HOME}/.nvm/nvm.sh"

if [ ! -e ${HOME}/.nvm ] ; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi

nvm install node
nvm alias default node
nvm use node
npm install
npm install -g
npm update

echo '==================================================================================================='
echo 'UPDATE CUSTOM TOOLS'
echo 'Update hadolint'
HADOLINT_GIT_API="$(curl --no-progress-meter https://api.github.com/repos/hadolint/hadolint/releases/latest)"
HADOLINT_VERSION=$(echo "${HADOLINT_GIT_API}" |grep "tag_name" |sed -r 's/.*([0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2})",/\1/g')
if ! (hadolint --version | grep -q $HADOLINT_VERSION) ;then
  HADOLINT_URL=$(echo "${HADOLINT_GIT_API}" |grep "Linux-x86_64" | grep "download" |sed 's/.*\(https.*\)"/\1/g')
  wget -q -O ${HOME}/bin/hadolint $HADOLINT_URL
  chmod +x ${HOME}/bin/hadolint
fi

echo "Update k9s"
K9S_GIT_API="$(curl --no-progress-meter https://api.github.com/repos/derailed/k9s/releases/latest)"
K9S_VERSION=$(echo "${K9S_GIT_API}" |grep "tag_name" |sed -r 's/.*([0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2})",/\1/g')
if ! (k9s version |grep -q ${K9S_VERSION}) ;then
  K9S_URL=$(echo "${K9S_GIT_API}" |grep "Linux_x86_64" | grep "download" |sed 's/.*\(https.*\)"/\1/g')
  wget -q -O /tmp/k9s.tar.gz $K9S_URL
  tar -xvf /tmp/k9s.tar.gz -C ${HOME}/bin k9s
fi

mkdir -p ${HOME}/tools
cd ${HOME}/tools || (echo "Failed to enter ${HOME}/tools" && exit)

echo "Update Lua Language Server"
LUA_GIT_API="$(curl --no-progress-meter https://api.github.com/repos/sumneko/lua-language-server/releases/latest)"
LUA_LSP_VERSION=$(echo "${LUA_GIT_API}" |grep "tag_name" |sed -r 's/.*([0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2})",/\1/g')
LUA_LSP_DIR=${HOME}/tools/lua-language-server
if ! (${LUA_LSP_DIR}/bin/luals.sh --version | grep -q ${LUA_LSP_VERSION}) ;then
  LUA_DOWNLOAD_URL=$(echo "${LUA_GIT_API}" |grep "linux-x64" | grep "download" |sed 's/.*\(https.*\)"/\1/g')
  wget -q -O /tmp/luals.tar.gz $LUA_DOWNLOAD_URL
  mkdir -p $LUA_LSP_DIR
  tar -xf /tmp/luals.tar.gz -C $LUA_LSP_DIR
  echo "exec \"${LUA_LSP_DIR}/bin/lua-language-server\" \"\$@\"" > ${LUA_LSP_DIR}/bin/luals.sh
  chmod +x ${LUA_LSP_DIR}/bin/luals.sh
fi

echo "Update Groovy Language Server"
GROOVY_LSP_DIR=${HOME}/tools/groovy-language-server
if [ ! -e $GROOVY_LSP_DIR ] ;then git clone https://github.com/GroovyLanguageServer/groovy-language-server.git ;fi
cd $GROOVY_LSP_DIR || (echo "Failed to enter ${GROOVY_LSP_DIR}" && exit)
if test ! -d build || git remote show origin | grep -q 'out of date' ;then
  git pull
  ./gradlew clean build -x test
fi
cd ${HOME}/tools || (echo "Failed to enter ${HOME}/tools" && exit)

echo "Update Puppet Language Server"
PUPPET_LSP_DIR=${HOME}/tools/puppet-editor-services
if [ ! -e $PUPPET_LSP_DIR ] ;then git clone https://github.com/puppetlabs/puppet-editor-services.git ;fi
cd $PUPPET_LSP_DIR || (echo "Failed to enter ${PUPPET_LSP_DIR}" && exit)
if test ! -f Gemfile.lock || git remote show origin | grep -q "out of date" ;then
  git pull
  bundle install
fi
cd ${HOME}/tools || (echo "Failed to enter ${HOME}/tools" && exit)

echo "Puppet Treesitter setup"
PUPPET_TS_DIR=${HOME}/tools/tree-sitter-puppet
PUPPET_Q_DIR=${HOME}/.local/share/nvim/site/pack/packer/start/nvim-treesitter/queries/puppet
if [ ! -e $PUPPET_TS_DIR ] ;then git clone https://github.com/neovim-puppet/tree-sitter-puppet.git ;fi
cd $PUPPET_TS_DIR || (echo "Failed to enter ${PUPPET_TS_DIR}" && exit)
git pull
if [ ! -e $PUPPET_Q_DIR ] ;then mkdir -p $PUPPET_Q_DIR ;fi
cp ${PUPPET_TS_DIR}/queries/* ${PUPPET_Q_DIR}/
cd ${HOME}/tools || (echo "Failed to enter ${HOME}/tools" && exit)

echo '==================================================================================================='
echo 'SETUP WINDOWS TOOLS CONFIGURATION'
cp ${CONF}/viebrc /mnt/c/Users/${USER}/.viebrc
cp ${CONF}/wezterm.lua /mnt/c/Users/${USER}/.wezterm.lua
