@echo off

java -jar KickAss.jar ASM\LogoDisplay.asm -odir ../obj

.\Sparkle.exe .\Disk.sls

REM ..\GenesisProject\Extras\VICE\bin\c1541.exe -attach C64GFXLogoCompo.d64 -write notefile.prg "notefile     /gp"

pause