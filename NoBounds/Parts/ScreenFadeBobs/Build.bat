@echo off
SET KICKASS="..\..\Extras\KickAss\KickAss.jar"

del ScreenFadeBobs.prg /f
java -jar %KICKASS%  -vicesymbols ScreenFadeBobs.asm -o ScreenFadeBobs.prg 
Taskkill /IM x64sc.exe /F
start x64sc.exe  -moncommands ScreenFadeBobs.vs ScreenFadeBobs.prg 
