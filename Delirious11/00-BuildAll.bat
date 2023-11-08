java -jar Extras\KickAss\KickAss.jar SourceCode\Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\Main-IRQManager.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\StartupScreenFade-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\StartupScreenFade2-Rasters-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\BedIntro-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\PreAndPostCreditsFade-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\SimpleCredits-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\FullScreenRasters-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\LogoFader-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\ScreenHash-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\SpriteBobs-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\MassiveLogo-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\TheEye-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\Greetings-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\UpScrollCredits-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\WavyLineCircle-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\Headache-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\RotatingStars-Main.asm -odir ..\Intermediate
java -jar Extras\KickAss\KickAss.jar SourceCode\EndCredits-Main.asm -odir ..\Intermediate

Extras\Spindle\win32\spin.exe script -e 0200 -t "NOTHING SERIOUS" -o Delirious11.d64 -v -a SourceData\Delirious11DirArt.txt -d 20

pause

