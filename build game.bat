color 4F	
@ECHO OFF
title VideahEngine Build System

::: _____  _    _            _    _____            _           
:::|  |  ||_| _| | ___  ___ | |_ |   __| ___  ___ |_| ___  ___ 
:::|  |  || || . || -_|| .'||   ||   __||   || . || ||   || -_|
::: \___/ |_||___||___||__,||_|_||_____||_|_||_  ||_||_|_||___|
:::                                          |___|             


GOTO START

:START
cls
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
echo  -----------------------------------------
echo ^| What platform do you want to build for? ^|
echo ^| Windows = 1                             ^|
echo ^| Mac OS = 2                              ^|
echo  -----------------------------------------
echo.
set/p "cho=>"
if %cho%==1 GOTO WIN
if %cho%==2 GOTO MAC
goto START

:WIN
cls
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
echo  ---------------------------------------------
echo ^| What architecture do you want to build for? ^|
echo ^| x86 = 1                                     ^|
echo ^| x64 = 2                                     ^|
echo  ---------------------------------------------
echo.
set/p "cho=>"
if %cho%==1 GOTO WIN32
if %cho%==2 GOTO WIN64
goto WIN

:WIN64
ECHO Building VideahEngine 64-bit . . .
SET RELEASEDIR="Release"
MKDIR %RELEASEDIR%
CD bin\x64\win64\love
GOTO BUILD

:WIN32
echo Building VideahEngine 32-bit . . .
SET RELEASEDIR="Release (x86)"
MKDIR %RELEASEDIR%
CD bin\x86\win32\love
GOTO BUILD

:BUILD
ECHO Building in 3 . . .
SLEEP 1
ECHO 2
SLEEP 1
ECHO 1
SLEEP 1
XCOPY * ..\..\..\..\%RELEASEDIR% /S /Y
CD ..\..\..\..\src
..\bin\x86\win32\7za.exe a -tzip -mx9 ..\%RELEASEDIR%\game.love engine game LICENCE main.lua conf.lua
CD ..\%RELEASEDIR%
COPY /b love.exe+game.love game.exe
DEL love.exe
DEL game.love
CD ..
ECHO Build Successful!
PAUSE