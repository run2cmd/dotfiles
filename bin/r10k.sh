#!/bin/bash
PUPPET_MASTER_IPS=$(rg -I puppet_master_ip: | awk '{print $2}' | sed "s/'//g;s/\"//g" | tr -s "\n" ",")
ENV_NAME="$(basename $(pwd))_$(git branch --show-current)"

echo "Run r10k with environment ${ENV_NAME} on ${PUPPET_MASTER_IPS}"
ansible-playbook -i $PUPPET_MASTER_IPS -u root /dev/stdin <<FOO
- hosts: all
  gather_facts: false
  tasks:
    - command: "r10k deploy environment ${ENV_NAME} -pv"
FOO
