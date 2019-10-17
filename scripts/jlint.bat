@echo off
type %1 | ssh -l %2 -oKexAlgorithms=+diffie-hellman-group1-sha1 %3 -p %4 declarative-linter
