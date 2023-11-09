@echo off
SET KICKASS="..\..\Extras\KickAss\KickAss.jar"

del ReflectorTW.prg /f
del DISK-ReflectorTW.prg /f
java -jar %KICKASS%  -vicesymbols ReflectorTW.asm -o ReflectorTW.prg 

java -jar %KICKASS%  -vicesymbols ReflectorTransition.asm -o ReflectorTransition.prg 

java -jar %KICKASS%  DISK-ReflectorTW.asm -o DISK-ReflectorTW.prg 

Taskkill /IM x64sc.exe /F
start x64sc.exe  -moncommands ReflectorTW.vs ReflectorTW.prg 

