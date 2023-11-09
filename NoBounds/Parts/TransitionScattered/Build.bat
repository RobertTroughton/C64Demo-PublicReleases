@echo off
SET KICKASS="..\..\Extras\KickAss\KickAss.jar"

del TransitionScattered.prg /f
java -jar %KICKASS%  -vicesymbols DISK-TransitionScattered.asm -o DISK-TransitionScattered.prg 
java -jar %KICKASS%  -vicesymbols TransitionScattered.asm -o TransitionScattered.prg 
Taskkill /IM x64sc.exe /F
start x64sc.exe  -moncommands TransitionScattered.vs TransitionScattered.prg 
