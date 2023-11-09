@echo off
SET KICKASS="..\..\Extras\KickAss\KickAss.jar"

del TechTech.prg /f
java -jar %KICKASS%  -vicesymbols TechTech.asm -o TechTech.prg 

java -jar %KICKASS%  DISK-TechTech.asm -o DISK-TechTech.prg 

Taskkill /IM x64sc.exe /F


echo Crunching...
exomizer.exe sfx $9700 TechTech.prg -oTechTechCrunch.prg -q
echo done!

start x64sc.exe  -moncommands TechTech.vs TechTechCrunch.prg 