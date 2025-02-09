��&cls
@echo off
cls
color 05

:: Set the title for the batch window
title KORTEX HUB

:: Check if the script is running as Administrator
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo This script requires Administrator privileges.
    echo Trying to run as Administrator...
    :: Relaunch the script as Administrator in the current directory
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d %~dp0 && %~dp0%~nx0' -Verb RunAs"
    exit /b
)

:: Check if the script is already running by checking for an existing instance
set "scriptName=%~nx0"
tasklist /FI "IMAGENAME eq cmd.exe" /FI "WINDOWTITLE eq KORTEX HUB" | findstr /i "%scriptName%" >nul
if %errorlevel%==0 (
    echo The script is already running.
    timeout /t 2 /nobreak >nul
    exit /b
)

:: Center the text and display the first part
setlocal enabledelayedexpansion

:: Get console width
for /F "tokens=2 delims==" %%I in ('"mode con"') do set /A cols=%%I-1
set /A halfcols=cols/2

:: Display the first line (KORTEX HUB)
set "line1=KORTEX HUB"
for /L %%i in (1,1,!halfcols!) do set "sp= !sp!"
echo !sp!!line1!

:: Display the second line (Developed by sh5sui)
set "line2=developed by sh5sui"
for /L %%i in (1,1,!halfcols!) do set "sp= !sp!"
echo !sp!!line2!

:: Get the local user's UUID using PowerShell
for /f "delims=" %%i in ('powershell -Command "(Get-WmiObject -Class Win32_ComputerSystemProduct).UUID"') do set userUUID=%%i

:: Check if the local user's UUID is on the whitelisted list
echo Checking if your UUID is whitelisted...
powershell -Command "(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/sh5sui/testings/refs/heads/main/uuidtesting.txt').Content" | findstr /i "%userUUID%" >nul

if %errorlevel%==0 (
    echo You are whitelisted! Proceeding with the script.
    timeout /t 2 /nobreak >nul
) else (
    echo You are not whitelisted.
    timeout /t 3 >nul
    exit /b
)

:: Check if xeno.exe exists in the same directory
if exist "xeno.exe" (
    echo Xeno found.
) else (
    echo Xeno not found. Place this batch file in the same location as your Xeno.exe file
    timeout /t 2 /nobreak >nul
    exit /b
)

:: Check if xeno.exe is running
tasklist | findstr /i "xeno.exe" >nul
if %errorlevel%==0 (
    echo Please close xeno.exe to run this batch file.
    timeout /t 2 /nobreak >nul
    exit /b
)

:: Display the "Press any key to continue" text
set "line3=Press any key to continue..."
for /L %%i in (1,1,!halfcols!) do set "sp= !sp!"
echo !sp!!line3!

:: Wait for a key press
pause >nul

:: Redirect to the Pastebin URL to get the key
start "" "https://pastebin.com/raw/Q0Vuhe2k"

:: Clear screen and ask for key input
cls
echo Enter the key from the Pastebin:
set /p userKey= 

:: Monitor Task Manager for xeno.exe while waiting for key input
:monitor
:: Continuously check if xeno.exe is running and inform the user to close it
tasklist | findstr /i "xeno.exe" >nul
if %errorlevel%==0 (
    echo Please close xeno.exe to run this batch file.
    timeout /t 2 /nobreak >nul
    exit /b
)

:: Check if the key entered is correct
if /i "%userKey%"=="PWJGFSOP-TEWOHIASD-248921NDSF-3J4MSA-91234MSA" (
    echo Key correct! 
    echo Please wait.
    timeout /t 2 /nobreak >nul
    start "" "https://raw.githubusercontent.com/sh5sui/testings/refs/heads/main/helloalliamtesting"
    echo The browser should now open. The script is inside this github URL, Enjoy!

    :: Check if xeno.exe exists again and launch if found
    if exist "xeno.exe" (
        echo xeno.exe found! Launching xeno.exe...
        start "" "xeno.exe"
    ) else (
        echo xeno.exe not found in the same directory.
    )

    :: Wait for 5 seconds before closing the window
    timeout /t 5 /nobreak >nul

    :: Exit the current window instead of restarting
    exit /b
) else (
    echo Incorrect key. Exiting...
    timeout /t 2 /nobreak >nul
)

pause
