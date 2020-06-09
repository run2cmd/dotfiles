@echo off
for /f %%i in ('docker run -d -p 52222:52222 jenkins-env') do set dockerid=%%i
ssh-keygen -R [localhost]:52222 > nul
echo "Waiting 30 seconds for Jenkins on docker to come up"
timeout 30 > nul
type %1 | ssh -l admin -o StrictHostKeyChecking=no localhost -p 52222 declarative-linter
docker kill %dockerid% > nul
docker rm %dockerid% > nul
