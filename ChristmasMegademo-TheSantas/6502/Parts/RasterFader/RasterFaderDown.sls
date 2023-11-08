[Sparkle Loader Script]

Path:	..\..\..\D64\RasterFaderDown.d64
Header:	RasterFaderDown
ID:	disk1
Name:	RasterFaderDown
Start:	ff40
IL0:	5

File:	..\..\..\Out\6502\Main\Entry.prg

File:	..\..\..\Out\6502\Main\Main-BaseCode.prg
File:	..\..\Music\Mibri-Santas.sid

File:	..\..\..\Out\6502\Parts\RasterFader\DISK-RasterFader.prg
File:	..\..\..\Out\6502\Parts\RasterFader\RasterFaderDown.prg

'Preload some of next part
File:	..\..\..\Out\6502\Main\DISK-EndOfDisk.prg

'Finish loading next part
File:	..\..\..\Out\6502\Main\DISK-EndOfDisk.prg