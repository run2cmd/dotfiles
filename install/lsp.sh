#!/bin/bash
#
# Install additional LSP servers
#
LIBDIR=$(dirname "$(readlink -f $0)")
source ${LIBDIR}/lib.sh
TOOLSDIR=${HOME}/tools

task "Update Lua Language Server"
LUA_LSP_DATA=$(git_data https://api.github.com/repos/sumneko/lua-language-server/releases/latest)
LUA_LSP_DIR=${TOOLSDIR}/lua-language-server
if ! (${LUA_LSP_DIR}/bin/luals.sh --version | grep -q "$(echo ${LUA_LSP_DATA} | cut -d' ' -f1)") ;then
 mkdir -p $LUA_LSP_DIR
 wget -q -O /tmp/luals.tar.gz "$(echo ${LUA_LSP_DATA} | cut -d' ' -f2)"
 tar -xf /tmp/luals.tar.gz -C $LUA_LSP_DIR
 echo "exec \"${LUA_LSP_DIR}/bin/lua-language-server\" \"\$@\"" > ${LUA_LSP_DIR}/bin/luals.sh
 chmod +x ${LUA_LSP_DIR}/bin/luals.sh
fi

task "Update Groovy Language Server"
GROOVY_LSP_DIR=${TOOLSDIR}/groovy-language-server
if [ ! -e $GROOVY_LSP_DIR ] ;then git clone https://github.com/GroovyLanguageServer/groovy-language-server.git ${GROOVY_LSP_DIR} ;fi
if test ! -d ${GROOVY_LSP_DIR}/build || git -C ${GROOVY_LSP_DIR} remote show origin | grep -q 'out of date' ;then
 git -C ${GROOVY_LSP_DIR} pull
 ${GROOVY_LSP_DIR}/gradlew clean build -x test -p ${GROOVY_LSP_DIR}
fi

task "Update Puppet Language Server"
PUPPET_LSP_DIR=${TOOLSDIR}/puppet-editor-services
if [ ! -e $PUPPET_LSP_DIR ] ;then git clone https://github.com/puppetlabs/puppet-editor-services.git ${PUPPET_LSP_DIR} ;fi
if test ! -f ${PUPPET_LSP_DIR}/Gemfile.lock || git -C ${PUPPET_LSP_DIR} remote show origin | grep -q "out of date" ;then
 git -C ${PUPPET_LSP_DIR} pull
 bundle install --gemfile=${PUPPET_LSP_DIR}/Gemfile
 bundle exec rake -f ${PUPPET_LSP_DIR}/Rakefile gem_revendor
fi
