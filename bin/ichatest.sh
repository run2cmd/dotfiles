find profiles/ -iname '*.yaml' -o -iname '*.yml' | xargs -n 1 -I {} ajv --all-errors=true validate -s schemas/profiles.json -d {}

for yamlfile in $(find ./conf/ -iname '*.yaml'); do
  schemafile=schemas/${yamlfile%.*}.json
  if [ ! -e ${schemafile} ] ;then
    if [[ "${yamlfile}" =~ "config" ]] ;then schemafile=schemas/conf/jenkins/config.json ;fi
    if [[ "${yamlfile}" =~ "components" ]] ;then schemafile=schemas/conf/jenkins/components.json ;fi
  fi
  ajv --all-errors=true validate -s ${schemafile} -d ${yamlfile}
done

#find data/env -iname '*.yaml' -o -iname '*yaml' | xargs -n 1 -I {} ajv --all-errors=true validate -s schemas/data/env/env_file.json -d {}
