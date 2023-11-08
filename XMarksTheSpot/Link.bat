@echo off

copy SourceData\DiagonalBitmap\InitialBitmap.map Intermediate\Built\DiagonalBitmap\InitialBitmap.map
copy SourceData\DiagonalBitmap\InitialBitmap.col Intermediate\Built\DiagonalBitmap\InitialBitmap.col
copy SourceData\DiagonalBitmap\InitialBitmap.scr Intermediate\Built\DiagonalBitmap\InitialBitmap.scr

mkdir D64

Extras\Spindle\win32\spin.exe SpindleBuildScripts\Disk1.txt -f -e 0200 -t "X MARKS 1" -a SourceData\XMarks-Dir.txt -d 24 -o D64\XMARKS-1.d64 --next-magic 0x5e87e6 -v
if %errorlevel% neq 0 goto error

Extras\Spindle\win32\spin.exe SpindleBuildScripts\Disk2.txt -f -e c000 -t "X MARKS 2" -o D64\XMARKS-2.d64 --my-magic 0x5e87e6 --next-magic 0x7e5b1a -v
if %errorlevel% neq 0 goto error

Extras\Spindle\win32\spin.exe SpindleBuildScripts\Disk3.txt -f -t "X MARKS 3" -o D64\XMARKS-3.d64 --my-magic 0x7e5b1a --next-magic 0x7e5b1a -v
if %errorlevel% neq 0 goto error

Extras\VICE\bin\c1541 -attach D64\XMARKS-1.d64 -write AdditionalStuff\Note-Antichrist.prg "antichr-note /gp" -write AdditionalStuff\ProductionNotes.prg "product.notes/gp"

goto end
:error
pause
:end
