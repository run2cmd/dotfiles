#!/bin/bash
PUPPET_MASTER_IP=$(rg -I puppet_master_ip: |head -1 | awk '{print $2}' | sed "s/'//g;s/\"//g")
ENV_NAME="$(basename $(pwd))_$(git branch --show-current)"

echo "Run r10k with environment ${ENV_NAME} on ${PUPPET_MASTER_IP}"
echo "${PUPPET_MASTER_IP} \"r10k deploy environment ${ENV_NAME} -pv\""

ssh ${PUPPET_MASTER_IP} "r10k deploy environment ${ENV_NAME} -pv"
