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
CLS
FOR /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
ECHO  -----------------------------------------
ECHO ^| What platform do you want to build for? ^|
ECHO ^| Windows = 1                             ^|
ECHO ^| Mac OS = 2                              ^|
ECHO ^| Android = 3                             ^|
ECHO  -----------------------------------------
ECHO.
SET/p "cho=>"
IF %cho%==1 GOTO WIN
IF %cho%==2 GOTO MAC
IF %cho%==3 GOTO AND
GOTO START

:WIN
CLS
FOR /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
ECHO  ---------------------------------------------
ECHO ^| What architecture do you want to build for? ^|
ECHO ^| x86 = 1                                     ^|
ECHO ^| x64 = 2                                     ^|
ECHO  ---------------------------------------------
ECHO.
SET/p "cho=>"
IF %cho%==1 GOTO WIN32
IF %cho%==2 GOTO WIN64
GOTO WIN

:MAC
CLS
FOR /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
ECHO.
ECHO Building for Mac OS is currently unsupported.
ECHO.
PAUSE
GOTO QUIT


:AND
CLS
FOR /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
IF NOT EXIST bin\mobile\love-android-sdl2 (
	ECHO.
	ECHO Could not find bin\mobile\love-android-sdl2
	ECHO.
	ECHO love-android-sdl2 is required to build VideahEngine for android.
	ECHO Please download and build love-android-sdl2 then try again.
	ECHO.
	PAUSE
	GOTO QUIT) ELSE (
	
	ECHO TODO: Add android building :v
	PAUSE QUIT
	GOTO QUIT
	)

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

:QUIT