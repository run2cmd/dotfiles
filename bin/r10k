#!/bin/bash
ENV_NAME="$(basename $(pwd))_$(git branch --show-current)"
LOCATIONS=$(python3 -c "import yaml;print(','.join(list(yaml.safe_load(open('data/env/${ENV_NAME}.yaml'))['icha_infrastructure'].keys())))")

PUPPET_MASTER_IPS=$(rg -I --glob "{${LOCATIONS}}.yaml" puppet_master_ip: | awk '{print $2}' | sed "s/'//g;s/\"//g" | tr -s "\n" ",")

echo "Run r10k with environment ${ENV_NAME} in locations ${LOCATIONS} on ${PUPPET_MASTER_IPS}"
ansible-playbook -i $PUPPET_MASTER_IPS -u root /dev/stdin <<FOO
- hosts: all
  gather_facts: false
  tasks:
    - command: "r10k deploy environment ${ENV_NAME} -pv"
FOO
