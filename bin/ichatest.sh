#!/bin/bash

FAILED=0
trap 'FAILED=1' ERR

envName="$(basename $(pwd))_$(git rev-parse --abbrev-ref HEAD)"

find profiles/ -iname '*.yaml' -o -iname '*.yml' | xargs -i ajv --all-errors=true validate -s schemas/profiles.json -d {}

for yamlfile in $(find -path "./conf/*" -not -path "./conf/jenkins/*" -iname '*.yaml'); do ajv --all-errors=true validate -s schemas/${yamlfile%.*}.json -d ${yamlfile} ; done
for yamlfile in $(find ./conf/jenkins -iname '*.yaml'); do
  schemafile=schemas/${yamlfile%.*}.json
  filename=$(basename ${yamlfile})
  if [ ! -e ${schemafile} ] ;then
    if [ "${filename}" = 'config.yaml' ] ;then schemafile=schemas/conf/jenkins/config.json ;fi
    if [ "${filename}" = 'components.yaml' ] ;then schemafile=schemas/conf/jenkins/components.json ;fi
  fi
  ajv --all-errors=true validate -s ${schemafile} -d ${yamlfile}
done

if [ -f data/env/${envName}.yaml ] && [ -f schemas/data/env/env_file.json ] ; then ajv --all-errors=true validate -s schemas/data/env/env_file.json -d data/env/${envName}.yaml ; fi

if [ $FAILED = 0 ] ;then echo "SUCCESS" ;else echo "FAILED" ;fi
