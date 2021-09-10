@echo off

set testyaml=%1
set testschema=%2
set testfile="%USERPROFILE%\.vim\tmp\test.json"

echo Convert %testyaml% to %testfile%
echo Validate against %testschema%

REM Move to better-ajv-errors
ruby -ryaml -rjson -e "File.write('%testfile%', YAML.load_file('%testyaml%').to_json)" 
ajv validate -s %testschema% -d %testyaml%
