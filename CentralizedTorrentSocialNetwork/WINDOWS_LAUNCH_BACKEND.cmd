@echo off
chcp 65001

echo %~f0

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Запуск с правами администратора...
    :: Перезапускаем скрипт с правами администратора
    powershell -Command "Start-Process '%comspec%' -Argument '/c \"%~f0\"' -Verb RunAs"
    exit /b
) else (
    :: Ваш код, который требует прав администратора, ниже
    cd %~dp0
    echo Запуск локального сервера...
    taskkill /im client.exe /f
    start /b %~dp0client.exe

    set "programPath=%~dp0WINDOWS_LAUNCH_BACKEND.cmd"
    set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

    :: Создаем ярлык в папке автозапуска
    set "shortcutName=TorrentHostClient.lnk"
    set "shortcutPath=%startupFolder%\%shortcutName%"

    :: Проверяем, существует ли ярлык
    if exist "%shortcutPath%" (
        echo Ярлык автозапуска уже существует.
    ) else (
        echo Создание ярлыка в автозапуске...
        :: Используем PowerShell для создания ярлыка
        powershell -Command "$s=(New-Object -COMObject WScript.Shell).CreateShortcut('%shortcutPath%'); $s.TargetPath='%programPath%'; $s.Save()"
        
        if %errorlevel% neq 0 (
            echo Ошибка при создании ярлыка. Проверьте правильность пути.
        ) else (
            echo Ярлык автозапуска успешно создан.
        )
    )
)
