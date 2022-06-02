#!/bin/bash

echo '==================================================================================================='
echo 'UPDATE UBUNTU PACKAGES'

dpkg -l | grep -q " curl " || sudo apt install -y curl
dpkg -l | grep -q " apt-transport-https " || sudo apt install -y apt-transport-https

dpkg -l | grep -q " pdk "
if [ $? -eq 1 ] ;then
  wget -O /tmp/puppet-tools-release.deb https://apt.puppet.com/puppet-tools-release-bullseye.deb
  sudo dpkg -i /tmp/puppet-tools-release.deb
fi

if [ ! -e /etc/apt/sources.list.d/helm-debian.list ] ;then
  echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-debian.list
  curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
fi

sudo apt update 

TO_INSTALL=''
while read -r line ;do
  dpkg -l | grep -q " ${line} "
  if [ $? -eq 1 ] ;then
    TO_INSTALL="${TO_INSTALL} ${line}" 
  fi
done < ~/Rpmfile

if [ "${TO_INSTALL}" != '' ] ;then
  sudo apt install -y $TO_INSTALL
fi

sudo apt upgrade -y && sudo apt autoremove -y 

CONF=$(dirname "$(readlink -f $0)")

echo '==================================================================================================='
echo 'SETUP DOTFILES'

ln -snf ${CONF}/bash.d ~/.bash.d
ln -snf ${CONF}/bin ~/bin

ln -snf ${CONF}/vimrc ~/.vimrc
ln -snf ${CONF}/vim/autoload ~/.vim/autoload
ln -snf ${CONF}/vim/colors ~/.vim/colors
ln -snf ${CONF}/vim/minisnip ~/.vim/minisnip
ln -snf ${CONF}/vim/plugin ~/.vim/plugin
ln -snf ${CONF}/vim/scripts ~/.vim/scripts
ln -snf ${CONF}/vim/spell ~/.vim/spell
mkdir -p  ~/.vim/tmp
mkdir -p  ~/.vim/undofiles
mkdir -p  ~/.vim/backupfiles
touch ~/.vimlocal

ln -snf ${CONF}/ctags ~/.ctags
ln -snf ${CONF}/gitattributes ~/.gitattributes
ln -snf ${CONF}/gitconfig ~/.gitconfig
ln -snf ${CONF}/irbrc ~/.irbrc
ln -snf ${CONF}/rvmrc ~/.rvmrc
ln -snf ${CONF}/puppet-lint.rc ~/.puppet-lint.rc
ln -snf ${CONF}/reek ~/.reek
ln -snf ${CONF}/rubocop.yaml ~/.rubocop.yaml
ln -snf ${CONF}/screenrc ~/.screenrc
ln -snf ${CONF}/tmux.conf ~/.tmux.conf
ln -snf ${CONF}/vintrc.yaml ~/.vintrc.yaml
ln -snf ${CONF}/codenarc.groovy ~/.codenarc.groovy
ln -snf ${CONF}/yamllint ~/.yamllint

ln -snf ${CONF}/Pythonfile ~/Pythonfile
ln -snf ${CONF}/package.json ~/package.json
ln -snf ${CONF}/Gemfile ~/Gemfile
ln -snf ${CONF}/Rpmfile ~/Rpmfile

grep -q '\.bash\.d' ~/.profile
if [ $? -eq 1 ] ;then
  echo '# Laod custom dotfiles' >> ~/.profile
  echo 'for i in ~/.bash.d/* ;do source ${i} ;done' >> ~/.profile
fi

echo '==================================================================================================='
echo 'UPDATE VIM PLUGINS'
vim +"PlugUpdate" +qa

echo '==================================================================================================='
echo 'UPDATE RUBY'

if [ ! -e ~/.rvm ] ;then
  curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
  curl -sSL https://get.rvm.io | bash -s stable --version 2.4.10
  source '/home/pbugala/.rvm/scripts/rvm'
fi

rvm get stable
rvm install 2.4.10 --default
rvm install 2.7.3
gem install bundle
bundle update

echo '==================================================================================================='
echo 'UPDATE PYTHON'

if [ ! -e ~/.pyenv ] ;then
  export PYENV_GIT_TAG=v3.8.2
  curl https://pyenv.run | bash
fi

pyenv update
pyenv install -s 3.8.2
pyenv global 3.8.2
python -m pip install --upgrade pip
pip install -r ~/Pythonfile --upgrade

echo '==================================================================================================='
echo 'UPDATE SDKMAN'

if [ ! -e ~/.sdkman ] ;then
  curl -s 'https://get.sdkman.io' | bash
  source "${HOME}/.sdkman/bin/sdkman-init.sh"
fi

source "${HOME}/.sdkman/bin/sdkman-init.sh"
sdk update 
sdk install java 11.0.12-open
sdk install groovy 2.4.12
sdk install maven && sdk install gradle

echo '==================================================================================================='
echo 'UPDATE NODEJS'

source "${HOME}/.nvm/nvm.sh"

if [ ! -e ~/.nvm ] ; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi

nvm install --lts
nvm use --lts
npm install

echo '==================================================================================================='
echo 'UPDATE CUSTOM TOOLS'
echo 'Update hadolint'
sudo wget -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.10.0/hadolint-Linux-x86_64
sudo chmod +x /usr/local/bin/hadolint

echo 'Update codenarc'
CODENARC_PATH='/usr/local/lib/codenarc'
sudo mkdir -p $CODENARC_PATH
sudo wget -O $CODENARC_PATH/CodeNarc.jar https://repo1.maven.org/maven2/org/codenarc/CodeNarc/2.2.0/CodeNarc-2.2.0.jar 
sudo wget -O $CODENARC_PATH/GMetrics.jar https://repo1.maven.org/maven2/org/gmetrics/GMetrics/1.1/GMetrics-1.1.jar
sudo wget -O $CODENARC_PATH/cobertura.jar https://repo1.maven.org/maven2/net/sourceforge/cobertura/cobertura/2.1.1/cobertura-2.1.1.jar
sudo wget -O $CODENARC_PATH/groovy-all.jar https://repo1.maven.org/maven2/org/codehaus/groovy/groovy-all/2.4.12/groovy-all-2.4.12.jar
sudo wget -O $CODENARC_PATH/slf4j-api.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.35/slf4j-api-1.7.35.jar
sudo wget -O $CODENARC_PATH/slf4j-simple.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/1.7.35/slf4j-simple-1.7.35.jar

echo "Update k9s"
sudo wget -O /tmp/k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz
sudo tar -xvf /tmp/k9s.tar.gz -C /usr/local/bin k9s

echo '==================================================================================================='
echo 'SETUP WINDOWS TOOLS CONFIGURATION'
cp ${CONF}/viebrc /mnt/c/Users/${USER}/.viebrc
cp ${CONF}/wezterm.lua /mnt/c/Users/${USER}/.wezterm.lua
