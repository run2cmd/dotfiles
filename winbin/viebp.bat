@echo off
set privpath=%USERPROFILE%\vieb\private
rmdir /S /Q %privpath%\data
start /B "" "%USERPROFILE%\AppData\Local\Programs\Vieb\Vieb.exe" "--erwic=%privpath%\config.json" "--datafolder=%privpath%\data" "--config-file=%privpath%\viebrc"
