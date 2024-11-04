@echo off

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Запуск с правами администратора...
    :: Перезапускаем скрипт с правами администратора
    powershell -Command "Start-Process cmd -Argument '%~f0' -Verb RunAs"
    exit /b
)

:: Ваш код, который требует прав администратора, ниже
echo Привет, вы запустили этот скрипт с правами администратора!


taskkill /im client.exe /f

start /b %~dp0client.exe
start http://localhost:2929/client/html/index.html