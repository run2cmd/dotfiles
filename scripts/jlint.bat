@echo off
type %1 | ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 %2 -p %3 declarative-linter
