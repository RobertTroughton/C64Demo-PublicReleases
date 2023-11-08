@echo off

java -jar Extras\KickAss\KickAss.jar SourceCode\Entry.asm -odir ..\Intermediate\KickAss
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\Main-DefaultIRQ.asm -odir ..\Intermediate\KickAss
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\Main-Disk1.asm -odir ..\Intermediate\KickAss
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\Main-Disk2.asm -odir ..\Intermediate\KickAss
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\Main-Disk3.asm -odir ..\Intermediate\KickAss
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\AllBorders.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\EndCredits.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\FullScreenRotatingThings.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\HorizontalBitmap.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\RotatingShapes.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\ScreenHash.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\SpriteBobs.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\TreasureMap.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\TreasureMap-SpriteDottedLine.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\Waves.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\Waves-SpriteClip.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar Intermediate\Built\WavyScroller\Blit.asm -odir ..\..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\WavyScroller.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\WavySnakeLR.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\WavySnakeRL.asm -odir ..\..\Intermediate\KickAss\DemoParts
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\Extra\BitmapDisplay.asm -odir ..\..\Intermediate\KickAss\Extra
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\Extra\ScreenWipe.asm -odir ..\..\Intermediate\KickAss\Extra
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\Extra\CreditSprites.asm -odir ..\..\Intermediate\KickAss\Extra
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\Extra\TurnSide.asm -odir ..\..\Intermediate\KickAss\Extra
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\Extra\WrongDisk.asm -odir ..\..\Intermediate\KickAss\Extra
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\Shadow\textureflag-draw.asm -odir ..\..\..\Intermediate\KickAss\DemoParts\Shadow
if %errorlevel% neq 0 goto error

java -jar Extras\KickAss\KickAss.jar SourceCode\DemoParts\Shadow\textureflag.asm -odir ..\..\..\Intermediate\KickAss\DemoParts\Shadow
if %errorlevel% neq 0 goto error

goto end
:error
pause
:end
