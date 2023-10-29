@echo off

::This script is xclusively created by LAVA for ELITE KAMRUL::

title Windows Update Manager 4.0
color 1f
reg add "HKEY_CURRENT_USER\Console\%%SystemRoot%%_system32_cmd.exe" /v "ScreenBufferSize" /t REG_DWORD /d 0x23290050 /f >nul
reg add "HKEY_CURRENT_USER\Console\%%SystemRoot%%_system32_cmd.exe" /v "WindowSize" /t REG_DWORD /d 0x190050 /f >nul
:Begin UAC check and Auto-Elevate Permissions
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo:
echo ===============================================================================
echo 北北北北北北北北盵  Windows Auto Update Manager - ELITE KAMRUL  ]北北北北北北北北
echo ===============================================================================
echo.
echo.
echo.
echo Requesting Administrative Privileges.
echo.
echo Press YES in UAC prompt to continue...
echo.
echo.
echo.
echo ===============================================================================
echo.
echo:

    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

:Check the key:
(reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate"|find /i "0x1")>NUL 2>NUL
if %errorlevel% neq 0 GOTO :KEYOFF


:KEYON

echo.
echo ===============================================================================
echo 北北北北北北北北盵  Windows Auto Update Manager - ELITE KAMRUL  ]北北北北北北北北
echo ===============================================================================
echo.
echo.
echo.
echo Automatic Updates are currently switched OFF.
echo.
echo Would you like to enable them? Press (Y/N)
echo.
echo.
echo.
echo ===============================================================================
echo.
choice /c yn /n
If %ERRORLEVEL% NEQ 1 GOTO :QUIT

echo.
echo Turning on the Windows Update service.
net stop wuauserv>NUL 2>NUL

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /D "0" /T REG_DWORD /F>NUL 2>NUL
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Gwx" /v "DisableGwx" /D "0" /T REG_DWORD /F>NUL 2>NUL
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableOSUpgrade" /D "0" /T REG_DWORD /F>NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 GOTO :ERROR

goto :QUIT


:KEYOFF

echo.
echo ===============================================================================
echo 北北北北北北北北盵  Windows Auto Update Manager - ELITE KAMRUL  ]北北北北北北北北
echo ===============================================================================
echo.
echo.
echo.
echo Automatic Updates are currently switched ON.
echo.
echo Would you like to disable them? Press (Y/N)
echo.
echo.
echo.
echo ===============================================================================
echo.
choice /c yn /n
If %ERRORLEVEL% NEQ 1 GOTO :QUIT

echo.
echo Shutting down the Windows Update service.
net stop wuauserv>NUL 2>NUL

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /D "1" /T REG_DWORD /F>NUL 2>NUL
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /D "2" /T REG_DWORD /F>NUL 2>NUL
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Gwx" /v "DisableGwx" /D "1" /T REG_DWORD /F>NUL 2>NUL
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableOSUpgrade" /D "1" /T REG_DWORD /F>NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 GOTO :ERROR

goto :QUIT


:QUIT
echo.
echo ===============================================================================
echo.
echo.
echo.
echo Congrats operation successful.
echo.
echo Press any key to exit...
echo.
echo.
echo.
echo ===============================================================================
pause>NUL
goto :EOF

:ERROR
echo.
echo ===============================================================================
echo.
echo.
echo.
echo Script ran into an unexpected error.
echo.
echo Press any key to exit...
echo.
echo.
echo.
echo ===============================================================================
pause>NUL
goto :EOF