@echo off

mkdir ..\..\Intermediate\Compressed

java -jar ..\..\Extras\KickAss\KickAss.jar ASM\Entry.asm -odir ..\..\..\Intermediate\KickAss\Main
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ASM\Main-BaseCode.asm -odir ..\..\..\Intermediate\KickAss\Main
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ASM\DISK-TheDive.asm -odir ..\..\..\Intermediate\KickAss\Main
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\BigDYPP\ASM\BigDYPP.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\DeepSeaDots\ASM\DeepSeaDots.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\FullScreenRasterSweep\ASM\FullScreenRasterSweep.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\GPLogo\ASM\GPLogo.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\Quote\ASM\Quote.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\RotateScroller\ASM\RotateScroller.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error
java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\RotateScroller\ASM\RotateScroller-UnrolledCode.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\SideBorderBitmap\ASM\SideBorderBitmap.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\SpinnyShapes\ASM\SpinnyShapes.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\SpriteBobs\ASM\SpriteBobs.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\StarWars\ASM\StarWars.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\..\Intermediate\Built\StarWars\SW-Plot.asm -odir ..\..\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

..\..\Extras\NuCrunch\nucrunch-1.0.1\bin-win32\nucrunch.exe ..\..\Intermediate\KickAss\Main\Parts\sw-plot.prg -r -o ..\..\Intermediate\Compressed\sw-plot.nuc --auto
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\VertBitmap\ASM\VertBitmap.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\Parts\WaveFade\ASM\WaveFade.asm -odir ..\..\..\..\Intermediate\KickAss\Main\Parts
if %errorlevel% neq 0 goto error

java -jar ..\..\Extras\KickAss\KickAss.jar ..\ThirdParty\NUDecrunchForward.asm -odir ..\..\Intermediate\KickAss\ThirdParty
if %errorlevel% neq 0 goto error
java -jar ..\..\Extras\KickAss\KickAss.jar ..\ThirdParty\NUDecrunchReverse.asm -odir ..\..\Intermediate\KickAss\ThirdParty
if %errorlevel% neq 0 goto error

..\..\Extras\spindle\win32\spin.exe SpindleLayout-TheDive.txt -e 0200 -t "GENESIS PROJECT" -o TheDive.d64 -a Data\DirArt.txt -d 16 --next-magic 0x5e87e6 -v
if %errorlevel% neq 0 goto error

copy TheDive.d64 ..\..\

:end
if [%1]==[-unattended] goto exit

:error
pause

:exit