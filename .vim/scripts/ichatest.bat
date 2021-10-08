@echo off

setlocal ENABLEDELAYEDEXPANSION
set status=SUCCESS

REM Validate profiles
for /F %%F in ('fd -I "(ya|y)ml" profiles') do (
    echo off
    call ajv validate -s "schemas\profiles.json" -d %%F
    if !ERRORLEVEL! gtr 0 (
        echo [FAILED]
        set status=FAILED
    )
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
        if !ERRORLEVEL! gtr 0 (
            echo [FAILED]
            set status=FAILED
        )
    ) else (
        echo [FAILED] !schemafile! does not exists
        set status=FAILED
    )
)

echo Test %status%
