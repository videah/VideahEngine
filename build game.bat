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
ECHO  -----------------------------------------
ECHO ^| What platform do you want to build for? ^|
ECHO ^| Windows = 1                             ^|
ECHO ^| Mac OS = 2                              ^|
ECHO  -----------------------------------------
ECHO.
set/p "cho=>"
if %cho%==1 GOTO WIN
if %cho%==2 GOTO MAC
GOTO START

:WIN
cls
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
ECHO  ---------------------------------------------
ECHO ^| What architecture do you want to build for? ^|
ECHO ^| x86 = 1                                     ^|
ECHO ^| x64 = 2                                     ^|
ECHO  ---------------------------------------------
ECHO.
set/p "cho=>"
if %cho%==1 GOTO WIN32
if %cho%==2 GOTO WIN64
GOTO WIN

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