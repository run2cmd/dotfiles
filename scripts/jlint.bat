@echo off
type %1 | ssh -l %2 -o StrictHostKeyChecking=no %3 -p %4 declarative-linter
