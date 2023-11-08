@echo off

mkdir ..\..\..\Intermediate\Compressed

java -jar ..\..\..\Extras\KickAss\KickAss.jar ..\..\Main\ASM\Entry.asm -odir ..\..\..\Intermediate\KickAss\StarWars
if %errorlevel% neq 0 goto error

java -jar ..\..\..\Extras\KickAss\KickAss.jar ..\..\Main\ASM\Main-BaseCode.asm -odir ..\..\..\Intermediate\KickAss\StarWars
if %errorlevel% neq 0 goto error

java -jar ..\..\..\Extras\KickAss\KickAss.jar ..\..\ThirdParty\NUDecrunchForward.asm -odir ..\..\Intermediate\KickAss\StarWars
if %errorlevel% neq 0 goto error

java -jar ..\..\..\Extras\KickAss\KickAss.jar ..\..\ThirdParty\NUDecrunchReverse.asm -odir ..\..\Intermediate\KickAss\StarWars
if %errorlevel% neq 0 goto error

java -jar ..\..\..\Extras\KickAss\KickAss.jar ASM\DISK-StarWars.asm -odir ..\..\..\..\Intermediate\KickAss\StarWars
if %errorlevel% neq 0 goto error

java -jar ..\..\..\Extras\KickAss\KickAss.jar ASM\StarWars.asm -odir ..\..\..\..\Intermediate\KickAss\StarWars
if %errorlevel% neq 0 goto error

java -jar ..\..\..\Extras\KickAss\KickAss.jar ..\..\..\Intermediate\Built\StarWars\SW-Plot.asm -odir ..\..\..\Intermediate\KickAss\StarWars
if %errorlevel% neq 0 goto error

..\..\..\Extras\NuCrunch\nucrunch-1.0.1\bin-win32\nucrunch.exe ..\..\..\Intermediate\KickAss\StarWars\sw-plot.prg -r -o ..\..\..\Intermediate\Compressed\sw-plot.nuc --auto
if %errorlevel% neq 0 goto error

..\..\..\Extras\spindle\win32\spin.exe SpindleLayout-StarWars.txt -e 0200 -t "GENESIS PROJECT" -o StarWars.d64 --next-magic 0x5e87e6 -v
if %errorlevel% neq 0 goto error

:end
if [%1]==[-unattended] goto exit

:error
pause

:exit