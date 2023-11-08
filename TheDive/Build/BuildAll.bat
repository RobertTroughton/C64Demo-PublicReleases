del BuildLog.txt

cd main
call Build-Main.bat -unattended
cd ..\Parts\BigDYPP
call Build-BigDYPP.bat -unattended
cd ..\DeepSeaDots
call Build-DeepSeaDots.bat -unattended
cd ..\FullScreenRasterSweep
call Build-FullScreenRasterSweep.bat -unattended
cd ..\GPLogo
call Build-GPLogo.bat -unattended
cd ..\RotateScroller
call Build-RotateScroller.bat -unattended
cd ..\SideBorderBitmap
call Build-SideBorderBitmap.bat -unattended
cd ..\SpinnyShapes
call Build-SpinnyShapes.bat -unattended
cd ..\SpriteBobs
call Build-SpriteBobs.bat -unattended
cd ..\StarWars
call Build-StarWars.bat -unattended
cd ..\VertBitmap
call Build-VertBitmap.bat -unattended
pause
