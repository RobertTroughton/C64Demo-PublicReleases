@echo off
SET KICKASS="..\..\Extras\KickAss\KickAss.jar"

del SpriteFpp.prg /f
del DISK-SpriteFpp.prg /f
java -jar %KICKASS%  -vicesymbols SpriteFPP.asm -o SpriteFPP.prg 

java -jar %KICKASS%  DISK-SpriteFPP.asm -o DISK-SpriteFPP.prg 

Taskkill /IM x64sc.exe /F
start x64sc.exe  -moncommands SpriteFPP.vs SpriteFPP.prg 

echo Crunching...
exomizer.exe sfx $c300 SpriteFPP.prg -oSpriteFPPCrunch.prg -q
echo done!