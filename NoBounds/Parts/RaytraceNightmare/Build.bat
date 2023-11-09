@echo off
SET KICKASS="..\..\Extras\KickAss\KickAss.jar"

del RaytraceNightmare.prg /f
del DISK-RaytraceNightmare.prg /f
java -jar %KICKASS%  -vicesymbols RaytraceNightmare.asm -o RaytraceNightmare.prg 

@echo java -jar %KICKASS%  DISK-RaytraceNightmare.asm -o DISK-RaytraceNightmare.prg 

Taskkill /IM x64sc.exe /F
start x64sc.exe  -moncommands RaytraceNightmare.vs RaytraceNightmare.prg 

echo Crunching...
exomizer.exe sfx $3800 RaytraceNightmare.prg -oRaytraceNightmareCrunch.prg -q
echo done!