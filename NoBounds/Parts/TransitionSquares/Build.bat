@echo off
SET KICKASS="..\..\Extras\KickAss\KickAss.jar"

del TransitionSquares.prg /f
java -jar %KICKASS%  -vicesymbols DISK-TransitionSquares.asm -o DISK-TransitionSquares.prg 
java -jar %KICKASS%  -vicesymbols TransitionSquares.asm -o TransitionSquares.prg 
exomizer.exe sfx $ec10 TransitionSquares.prg -oTransitionSquaresCrunch.prg -q
Taskkill /IM x64sc.exe /F
start x64sc.exe  -moncommands TransitionSquares.vs TransitionSquares.prg 
