@echo off

java -jar ..\..\..\..\Extras\KickAss\KickAss.jar ..\..\Main\ASM\Entry.asm -odir ..\..\..\Intermediate\KickAss\SpriteBobs
if %errorlevel% neq 0 goto error

java -jar ..\..\..\..\Extras\KickAss\KickAss.jar ..\..\Main\ASM\Main-BaseCode.asm -odir ..\..\..\Intermediate\KickAss\SpriteBobs
if %errorlevel% neq 0 goto error

java -jar ..\..\..\..\Extras\KickAss\KickAss.jar ASM\DISK-SpriteBobs.asm -odir ..\..\..\..\Intermediate\KickAss\SpriteBobs
if %errorlevel% neq 0 goto error

java -jar ..\..\..\..\Extras\KickAss\KickAss.jar ASM\SpriteBobs.asm -odir ..\..\..\..\Intermediate\KickAss\SpriteBobs
if %errorlevel% neq 0 goto error

..\..\..\..\Extras\spindle\win32\spin.exe SpindleLayout-SpriteBobs.txt -e 0200 -t "GENESIS PROJECT" -o SpriteBobs.d64 --next-magic 0x5e87e6 -v
if %errorlevel% neq 0 goto error

:end
if [%1]==[-unattended] goto exit

:error
pause

:exit