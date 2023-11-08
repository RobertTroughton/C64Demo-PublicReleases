[Sparkle Loader Script]

Path:	..\..\..\D64\SnowflakeZoomer.d64
Header:	snowflakezoomer
ID:	disk1
Name:	snowflakezoomer
Start:	ff40
IL0:	5

File:	..\..\..\Out\6502\Main\Entry.prg

File:	..\..\..\Out\6502\Main\Main-BaseCode.prg
File:	..\..\Music\Mibri-Santas.sid

File:	..\..\..\Out\6502\Parts\SnowflakeZoomer\DISK-SnowflakeZoomer.prg
File:	..\..\..\Out\6502\Parts\SnowflakeZoomer\SnowflakeZoomer.prg
File:	Data\Bitmap.kla*											c000	0002	1f40
File:	Data\Bitmap.kla												e000	1f42	03e8
File:	Data\Bitmap.kla												d800	232a	03e8
File:	Data\JmpTab.bin												f800
File:	Data\OffsetTab.bin											4000
File:	Data\BitTab.bin												7f00

'Preload some of next part
File:	..\..\..\Out\6502\Main\DISK-EndOfDisk.prg

'Finish loading next part
File:	..\..\..\Out\6502\Main\DISK-EndOfDisk.prg