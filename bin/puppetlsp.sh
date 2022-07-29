#!/bin/bash
cd ~/tools/puppet-editor-services || (echo "No ~/tools/puppet-editor-services directory" && exit 1)
bundle exec ruby ./puppet-languageserver --stdio --puppet-settings=--modulepath,/code/a32-tools:/code/puppet:/code/puppet-forge #--debug=/home/pbugala/puppet.log
