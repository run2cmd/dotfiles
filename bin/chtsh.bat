@echo off

set url="https://cht.sh"
set params=%*
set query=%params: =/%
echo %query%
call curl %url%/%query%
