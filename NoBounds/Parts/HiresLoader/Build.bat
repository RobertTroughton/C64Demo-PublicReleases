@echo off
SET KICKASS="..\..\Extras\KickAss\KickAss.jar"

del HiresLoader.prg /f
del DISK-HiresLoader.prg /f
java -jar %KICKASS%  -vicesymbols HiresLoader.asm -o HiresLoader.prg 

@echo java -jar %KICKASS%  DISK-HiresLoader.asm -o DISK-HiresLoader.prg 

Taskkill /IM x64sc.exe /F
start x64sc.exe  -moncommands HiresLoader.vs HiresLoader.prg 

echo Crunching...
exomizer.exe sfx $2000 HiresLoader.prg -oHiresLoaderCrunch.prg -q
echo done!