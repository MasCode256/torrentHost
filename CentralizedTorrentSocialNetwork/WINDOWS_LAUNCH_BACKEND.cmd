@echo off

taskkill /im client.exe /f

start /b %~dp0client.exe