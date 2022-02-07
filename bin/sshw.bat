@echo off

setlocal 

set TERM=xterm-256color
ssh %*

endlocal
@echo on
