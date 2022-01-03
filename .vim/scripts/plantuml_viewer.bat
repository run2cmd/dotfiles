@echo off

:dockerRun
for /f %%i in ('docker run -d -p 8080:8080 plantuml/plantuml-server:tomcat') do set dockerid=%%i
echo %dockerid%

:sshClean
ssh-keygen -R [localhost]:52232 1> nul 2>&1

:dockerWait
echo Waiting 20 seconds for Jenkins on docker to come up
ping -n 10 127.0.0.1 > nul
set /A count=0

:testJenkins
set /A count=%count%+1
if %count% gtr 10 goto dockerCleanup
ping -n 10 127.0.0.1 > nul
echo %count% test attempt
call type %1 | ssh -l admin -o StrictHostKeyChecking=no localhost -p 52232 declarative-linter
if %errorlevel% gtr 0 (goto testJenkins) else (goto dockerCleanup)

:dockerCleanup
docker kill %dockerid% > nul
docker rm %dockerid% > nul
