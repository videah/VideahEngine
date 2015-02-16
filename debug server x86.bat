@ECHO OFF
GOTO :START

:START
ECHO Launching VideahEngine Server 32-bit in debug mode . . .
START bin\x86\win32\love\love.exe src -debug -dedicated
GOTO END

:END
ECHO Succesfully started VideahEngine!