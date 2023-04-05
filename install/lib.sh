#!/bin/bash

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
