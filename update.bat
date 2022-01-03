echo off

echo UPDATE SCOOP PACKAGES
call scoop update *

echo ===================================================================================================
echo UPDATE RUBY GEMS
call bundle update

echo ===================================================================================================
echo UPDATE PYTHON PACKAGES"
call pip install -r Pythonfile --upgrade

echo ===================================================================================================
echo UPDATE NPM PACKAGES
call npm install

echo ===================================================================================================
echo UPDATE VIM PLUGINS
call vim +"PlugUpdate" +qa

echo ===================================================================================================
echo UPDATE UBUNTU PACKAGES
call bash -lc "sudo apt autoremove -y && sudo apt update && sudo apt upgrade -y"

echo on
