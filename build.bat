@echo off
odin build ./engine -debug -build-mode:dll
odin build . -debug
