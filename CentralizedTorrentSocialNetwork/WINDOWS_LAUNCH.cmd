@echo off

taskkill /im client.exe /f

start /b %~dp0client.exe
start http://localhost:2929/client/html/index.html