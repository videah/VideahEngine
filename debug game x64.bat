@ECHO OFF
GOTO :START

:START
ECHO Launching VideahEngine 64-bit in debug mode . . .
START bin\x64\win64\love\love.exe src -debug
GOTO END

:END
ECHO Succesfully started VideahEngine!