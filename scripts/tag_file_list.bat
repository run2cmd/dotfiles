@ECHO OFF
rem Add fixtures for puppet files
git ls-files & git ls-files -o spec\\fixtures\\modules\\*.pp
