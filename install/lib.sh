#!/bin/bash

topic() {
  echo "$(tput bold)$(tput setaf 4)${1}$(tput sgr0)"
}

task() {
  echo "$(tput setaf 2)${1}$(tput sgr0)"
}

