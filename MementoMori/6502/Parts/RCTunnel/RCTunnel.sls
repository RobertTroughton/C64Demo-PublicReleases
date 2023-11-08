[Sparkle Loader Script]

Path:	..\..\..\D64\RCTunnel.d64
Header:	AllBorderDYPP
ID:		-G*P-
Name:	rctunnel/G*P
Start:	ff40

File:	..\..\..\Out\6502\Main\Entry.prg
File:	..\..\..\Out\6502\Main\Main-BaseCode.prg
File:	..\..\Music\Nightlord-Tears.sid
File:	..\..\..\Out\6502\Parts\RCTunnel\DISK-RCTunnel.prg

File:	..\..\..\Out\6502\Parts\RCTunnel\rctunnel.prg
File:	Data\credits.bin																			4000
File:	Data\charset.bin																			6800
File:	Data\addlo.bin																				f000
File:	Data\addhi.bin																				f200
File:	Data\fulldepth.bin																			f400
File:	Data\map.bin																				5800

;Dummy load
File:	Data\Bitmap.map*																			c000
File:	Data\Bitmap.map																				2800	0000	1800
File:	Data\Bitmap.map																				5800	0000	0c00