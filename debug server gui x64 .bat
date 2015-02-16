@ECHO OFF
GOTO :START

:START
ECHO Launching VideahEngine Server 64-bit in debug mode . . .
START bin\x64\win64\love\love.exe src -debug -dedicated -gui
GOTO END

:END
ECHO Succesfully started VideahEngine