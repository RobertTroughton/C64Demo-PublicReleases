[Sparkle Loader Script]

Path:	..\..\..\D64\RasterFaderUp.d64
Header:	RasterFaderUp
ID:	disk1
Name:	RasterFaderUp
Start:	ff40
IL0:	5

File:	..\..\..\Out\6502\Main\Entry.prg

File:	..\..\..\Out\6502\Main\Main-BaseCode.prg
File:	..\..\Music\Mibri-Santas.sid

File:	..\..\..\Out\6502\Parts\RasterFader\DISK-RasterFader.prg
File:	..\..\..\Out\6502\Parts\RasterFader\RasterFaderUp.prg

'Preload some of next part
File:	..\..\..\Out\6502\Main\DISK-EndOfDisk.prg

'Finish loading next part
File:	..\..\..\Out\6502\Main\DISK-EndOfDisk.prg