#!/bin/bash

topic() {
  echo "$(tput bold)$(tput setaf 4)${1}$(tput sgr0)"
}

task() {
  echo "$(tput setaf 2)${1}$(tput sgr0)"
}

git_data() {
  git_api="$(curl --no-progress-meter ${1})"
  echo "${git_api}"
}

git_version() {
  version=$(echo "${1}" | jq -r .tag_name)
  echo $version
}

git_url() {
  url=$(echo "${1}" | jq -r --arg name "${2}" '.assets[] | select(.name == $name).browser_download_url')
  echo $url
}

match_sha256sum() {
  git_sha="$(wget -qO- $1 | cut -d' ' -f1)"
  file_sha="$(sha256sum $2 | cut -d' ' -f1)"
  [ $git_sha == $file_sha ] && echo 'match' || echo 'no-match'
}

git_clone() {
  if [ ! -e $2 ] ;then
    git clone $1 $2
  fi
}

git_check_update() {
  status=0
  if test ! -e ${1}/${2} || (git -C $1 remote show origin | grep 'out of date') ; then status=1 ;fi
  echo $status
}
