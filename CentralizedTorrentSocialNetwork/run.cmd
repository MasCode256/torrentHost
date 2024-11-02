@echo off

taskkill /im server.exe /f

go build -o client.exe code\client\client.go
go build -o server.exe code\server\server.go

start /b server.exe
WINDOWS_LAUNCH_BACKEND.cmd