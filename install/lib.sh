#!/bin/bash

#
# Pretty topic print.
#
# @param $1 message to print
#
topic() {
  echo "$(tput bold)$(tput setaf 4)${1}$(tput sgr0)"
}

#
# Pretty task print. Has lower priority than topics.
#
# @param $1 message to print
#
task() {
  echo "$(tput setaf 2)${1}$(tput sgr0)"
}

#
# Get data from GIT API
#
# @param $1 Git api URL
#
git_data() {
  git_api="$(curl --no-progress-meter ${1})"
  echo "${git_api}"
}

#
# Get artifact version from Git API.
#
# @param $1 Git data as String
#
git_version() {
  version=$(echo "${1}" | jq -r .tag_name)
  echo $version
}

#
# Get download URL from Git API.
#
# @param $1 Git data as String
# @param $2 Artifact name
#
git_url() {
  url=$(echo "${1}" | jq -r --arg name "${2}" '.assets[] | select(.name == $name).browser_download_url')
  echo $url
}

#
# Validate sha256sum match for given artifact.
#
# @param $1 SHA artifact URL
# @param $2 File path to match sha256sum against.
#
match_sha256sum() {
  git_sha="$(wget -qO- $1 | cut -d' ' -f1)"
  file_sha="$(sha256sum $2 | cut -d' ' -f1)"
  [ $git_sha == $file_sha ] && echo 'match' || echo 'no-match'
}

#
# Clone git repository.
#
# @param $1 Git url
# @param $2 Destination directory
#
git_clone() {
  if [ ! -e $2 ] ;then
    git clone $1 $2
  fi
}

#
# Check if file has updates in Git.
#
# @param $1 Directory path to Git repository
# @param $2 File name
#
git_check_update() {
  status=0
  if test ! -e ${1}/${2} || (git -C $1 remote show origin | grep 'out of date') ; then status=1 ;fi
  echo $status
}
