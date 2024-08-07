#!/bin/bash

topic() {
  echo "$(tput bold)$(tput setaf 4)${1}$(tput sgr0)"
}

task() {
  echo "$(tput setaf 2)${1}$(tput sgr0)"
}

git_data() {
  git_api="$(curl --no-progress-meter https://api.github.com/repos/${1}/releases/latest)"
  version=$(echo "${git_api}" | jq -r .tag_name)
  url=$(echo "${git_api}" | jq -r --arg name "${2}" 'first(.assets[] | select(.name | contains($name)).browser_download_url)')
  echo "(
    [version]='${version}'
    [url]='${url}'
  )"
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
