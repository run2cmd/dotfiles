@ECHO OFF
rg --files 
rem Add fixtures for puppet files
rg --files --type puppet spec/fixtures/modules --no-messages
