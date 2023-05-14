@echo off

start cmd /k java Server
start cmd /k java MoniteurImpl

for /L %%i in (1,1,2) do (
    start cmd /k java Irc test_%%i
)
