@echo off

start cmd /k java Server
timeout /t 1
start cmd /k java MoniteurImpl
timeout /t

for /L %%i in (1,1,2) do (
    start cmd /k java Irc test_%%i
)