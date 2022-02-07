@echo off

setlocal ENABLEDELAYEDEXPANSION
set status=SUCCESS

REM Vvalidate Yaml files
call yamllint data profiles
call :error_function

REM Validate profiles
for /F %%F in ('fd -I "(ya|y)ml" profiles') do (
    echo off
    call ajv validate -s "schemas\profiles.json" -d %%F
    call :error_function
)

REM Validate jenkins
for /F %%F in ('fd -I "(ya|y)ml" conf') do (
    echo off
    echo %%F
    set schemafile=%%F
    set schemafile=!schemafile:yaml=json!
    set schemafile=!schemafile:yml=json!
    set schemafile=schemas\!schemafile!
    if exist !schemafile! (
        call ajv validate -s !schemafile! -d %%F
        call :error_function
    ) else (
        echo [FAILED] !schemafile! does not exists
        set status=FAILED
    )
)

echo Test %status%

:error_function
if !ERRORLEVEL! gtr 0 (
    set status=FAILED
)
