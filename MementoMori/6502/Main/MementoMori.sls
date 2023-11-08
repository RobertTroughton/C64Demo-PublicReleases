[Sparkle Loader Script]

Path:	..\..\D64\MementoMori-Disk1.d64
Header:	Memento Mori 1
ID:		-G*P-
Name:	Memento Mori/G*P
Start:	ff40
DirArt:	Data\directory_art_01.d64
IL0:	5
IL1:	4

;Bundle #00 - Skull Zoomer
File:	..\..\Out\6502\Main\Entry-WithSkullZoomer.prg
File:	..\..\Out\6502\Main\SkullZoomer.prg
File:	..\Music\Meme.sid

;Bundle #01
File:	..\..\Out\6502\Main\Main-BaseCode.prg
File:	..\..\Out\6502\Main\DISK-MementoMori-A.prg
File:	..\Parts\Sparkle\Data\sparkle_chars.bin														8000
File:	..\Parts\Sparkle\Data\sparkle_sprite.bin													86c0
File:	..\Parts\Sparkle\Data\sparkle_map.bin														8800
File:	..\..\Out\6502\Parts\Sparkle\sparkle.prg

;Bundle #02 - Tunnel
File:	..\..\Out\6502\Parts\RCTunnel\rctunnel.prg
File:	..\Parts\RCTunnel\Data\credits.bin															4000
File:	..\Parts\RCTunnel\Data\charset.bin															6800
File:	..\Parts\RCTunnel\Data\addlo.bin															f000
File:	..\Parts\RCTunnel\Data\addhi.bin															f200
File:	..\Parts\RCTunnel\Data\fulldepth.bin														f400
File:	..\Parts\RCTunnel\Data\map.bin																5800

;Bundle #03 - Preloading the Rotating GP bitmap and segments of RotatingGP.prg and BlitData.bin to fill gaps in RAM
File:	..\..\Out\6502\Parts\RotatingGP\RotatingGP.prg												2800	0802	1800
File:	..\Parts\RotatingGP\Data\bitmap.map*														c000
File:	..\..\Out\6502\Parts\RotatingGP\BlitData.bin												5800	0800	0c00

;Bundle #04 - Rotating GP FadeIn
File:	..\..\Out\6502\Parts\RotatingGP\RotatingGP-Bitmap-FadeIn.prg
File:	..\..\Out\6502\Parts\RotatingGP\RotatingGP-Bitmap.prg
File:	..\Parts\RotatingGP\Data\bitmap.col															e000
File:	..\Parts\RotatingGP\Data\bitmap.scr															e400
File:	..\..\Out\6502\Parts\RotatingGP\FramesDarker.bin											e800

;Bundle #05 - Loading the remaining segments of RotatingGP.prg and BlitData.bin
File:	..\..\Out\6502\Parts\RotatingGP\RotatingGP.prg												2000	0002	0800
File:	..\..\Out\6502\Parts\RotatingGP\RotatingGP.prg												4000	2002
File:	..\..\Out\6502\Parts\RotatingGP\BlitData.bin												5000	0000	0800
File:	..\..\Out\6502\Parts\RotatingGP\BlitData.bin												6400	1400

;Bundle #06
File:	..\..\Out\6502\Parts\RotatingGP\XPosSinTable.bin											f400
File:	..\..\Out\6502\Parts\RotatingGP\BaseSpritesInterleaved.bin									e000

;Bundle #07
File:	..\..\Out\6502\Parts\RotatingGP\RotatingGP-Bitmap-FadeOut.prg
File:	..\..\Out\6502\Parts\RotatingGP\RotatingGP-Bitmap.prg
File:	..\Parts\RotatingGP\Data\bitmap.col															e000
File:	..\Parts\RotatingGP\Data\bitmap.scr															e400
File:	..\..\Out\6502\Parts\RotatingGP\FramesDarker.bin											e800

;Bundle #09 - Presents
File:	..\Parts\Presents\Data\sprites.map															c400
File:	..\..\Out\6502\Parts\Presents\presents.prg

;Bundle #0a - Preloading BigMMLogo
File:	..\..\Out\6502\Parts\BigMMLogo\BigMMLogo.prg
File:	..\..\Out\6502\Parts\BigMMLogo\BlitData.bin													8000
File:	..\..\Out\6502\FlipByteLookup.bin															b300
File:	..\..\Out\6502\Parts\BigMMLogo\SinTables.bin												b400
File:	..\..\Out\6502\Parts\BigMMLogo\PackedStrips.bin												6600
File:	..\..\Out\6502\Parts\BigMMLogo\LogoStripIndices.bin											a800
File:	..\..\Out\6502\Parts\BigMMLogo\CharSets.bin*												d000

;Bundle #0b
File:	..\..\Out\6502\Parts\AllBorderDYPP\AllBorderDYPP.prg
File:	..\Parts\AllBorderDYPP\Data\top.iscr														c800
File:	..\Parts\AllBorderDYPP\Data\top.iscr														cc00
File:	..\Parts\AllBorderDYPP\Data\bot.iscr														c9e0
File:	..\Parts\AllBorderDYPP\Data\bot.iscr														cde0
File:	..\Parts\AllBorderDYPP\Data\bot.imap*														d000
File:	..\Parts\AllBorderDYPP\Data\top.col															f000
File:	..\Parts\AllBorderDYPP\Data\top.imap*														d800
File:	..\Parts\AllBorderDYPP\Data\bot.col															f1e0

;Bundle #0c
File:	..\..\Out\6502\Parts\AllBorderDYPP\MainIRQ.prg
File:	..\..\Out\6502\Parts\AllBorderDYPP\Font.bin													6e00
File:	..\..\Out\6502\Parts\AllBorderDYPP\SpriteXVals.bin											fc00
File:	..\..\Out\6502\Parts\AllBorderDYPP\ScrollText.bin											c400

;Bundle #0d - Preloading part of riders.kla
File:	..\Parts\HorseMenPic\data\riders.kla														f400	1402	0800

;Bundle #0d
File:	..\..\Out\6502\Parts\HorseMenPic\HorseMenPic.prg
File:	..\Parts\HorseMenPic\data\riders.kla														e000	0002	1400
File:	..\Parts\HorseMenPic\data\riders.kla														fc00	1c02	0340
File:	..\Parts\HorseMenPic\data\riders.kla*														dc00	1f42	03e8
File:	..\Parts\HorseMenPic\data\riders.kla														d800	232a	03e8

;Bundle #0e
File:	..\..\Out\6502\Parts\TurnDiskDYPP\TurnDiskDYPP.prg
File:	..\..\Out\6502\Parts\TurnDiskDYPP\CharSet.bin												4000	0000	2800
File:	..\..\Out\6502\Parts\TurnDiskDYPP\Sprites.bin												7000
File:	..\..\Out\6502\Parts\TurnDiskDYPP\ScreenAnims.bin											9000

;Bundle #0f
File:	..\..\Out\6502\Parts\TurnDiskDYPP\CharSet.bin												e000	2800	800
File:	..\..\Out\6502\Parts\TurnDiskDYPP\CharSet.bin*												d800	3000	800
File:	..\..\Out\6502\Parts\TurnDiskDYPP\CharSet.bin*												d000	3800	800
File:	..\..\Out\6502\Parts\TurnDiskDYPP\CharSet.bin												c800	4000	800
File:	..\..\Out\6502\Parts\TurnDiskDYPP\Sprites.bin												f000

New Disk

Path:	..\..\D64\MementoMori-Disk2.d64
Header:	Memento Mori 2
ID:		-G*P-
Name:	Memento Mori/G*P
Start:	ff40
DirArt:	Data\directory_art_02.d64
IL0:	5
IL1:	4

;Bundle #00
File:	..\..\Out\6502\Main\Entry.prg
File:	..\..\Out\6502\Main\Main-BaseCode.prg
File:	..\..\Out\6502\Main\DISK-MementoMori-B.prg

;Bundle #01
File:	..\Music\Stinsen-MM.sid

;Bundle #02
File:	..\..\Out\6502\Parts\OdinQuote\OdinQuote.prg
File:	..\Parts\OdinQuote\Data\Odin.imap															c000
File:	..\Parts\OdinQuote\Data\Odin.iscr															c800

;Bundle #03
File:	..\..\Out\6502\Parts\BigScalingScroller\BigScalingScroller.prg
File:	..\..\Out\6502\Parts\BigScalingScroller\CharSets.bin										4000	0000	3800
File:	..\..\Out\6502\Parts\BigScalingScroller\PackedCharLookups.bin								8000
File:	..\..\Out\6502\Parts\BigScalingScroller\ScrollText.bin										2e00

;Bundle #04 - Preloading Hourglass.prg
File:	..\..\Out\6502\Parts\Hourglass\Hourglass.prg
File:	..\Parts\Hourglass\Data\sprites_final.bin*													c400
File:	..\Parts\Hourglass\Data\hourglass_optimized.bin											    e000	0000	1f40
File:	..\Parts\Hourglass\Data\hourglass_optimized.bin											    3800	1f40	03e8
File:	..\Parts\Hourglass\Data\hourglass_optimized.bin											    3c00	2328

;Bundle #05 - Preloading the PlotSkull part
File:	..\..\Out\6502\Parts\PlotSkull\PlotSkull.prg
File:	..\Parts\PlotSkull\Data\Bitmap.kla															a000	0002	1f40
File:	..\..\Out\6502\Parts\PlotSkull\Preps.prg
File:	..\Parts\PlotSkull\Data\MulTab.bin															4a00
File:	..\Parts\PlotSkull\Data\RowMax.bin															4a60
File:	..\Parts\PlotSkull\Data\JmpTab.bin															4a80
File:	..\Parts\PlotSkull\Data\OffsetTab.bin														5300	0300

;Bundle #06 - PlotSkull bitmap colors
File:	..\Parts\PlotSkull\Data\Bitmap.kla															d800	232a	03e8
File:	..\Parts\PlotSkull\Data\Bitmap.kla*															dc00	1f42	03e8
File:	..\Parts\PlotSkull\Data\Bitmap.kla															d021	2712

;Bundle #07	- PlotSkull
File:	..\Parts\PlotSkull\Data\OffsetTab.bin														5000	0000	0300

;Bundle #08 - Plotskull
File:	..\Parts\PlotSkull\Data\BitTab.bin*															9600

;Bundle #09 - Preloading ABDDYPP during fade-out of Plotskull
File:	..\..\Out\6502\Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP.prg							2200	0202
File:	..\..\Out\6502\Parts\AllBorderDoubleDYPP\ScrollText0.bin									bc00
File:	..\..\Out\6502\Parts\AllBorderDoubleDYPP\ScrollText1.bin									bd80
File:	..\..\Out\6502\Parts\AllBorderDoubleDYPP\SpriteXVals.bin									b800
File:	..\..\Out\6502\Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP-JustRasters.prg
File:	..\..\Out\6502\Parts\AllBorderDoubleDYPP\FadeSinTable.bin									bf00

;Bundle #0a - Remaining $200 bytes of ABDDYPP
File:	..\..\Out\6502\Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP.prg							2000	0002	0200

;Bundle #0b - Preloading the MC Plasma bitmap
File:	..\Parts\MCPlasma\Data\Bitmap.kla*															c000	0002	1f40

;Bundle #0c - MC Plasma
File:	..\..\Out\6502\Parts\MCPlasma\MCPlasma.prg
File:	..\Parts\MCPlasma\Data\Pattern.bin															9000
File:	..\Parts\MCPlasma\Data\Sprites.map															e400
File:	..\Parts\MCPlasma\Data\Charmap.bin															8600
File:	..\Parts\MCPlasma\Data\Bitmap.kla															e000	1f42	03e8
File:	..\Parts\MCPlasma\Data\Bitmap.kla															d800	232a	03e8
File:	..\Parts\MCPlasma\Data\Bitmap.kla															d021	2712

;Bundle #0d - Preloading part of FacetSkullPic
File:	..\Parts\FacetSkull\data\FacetSkull.kla														e600	0602	1940

;Bundle #0e - Loading color RAM colors of FacetSkullPic
File:	..\..\Out\6502\Parts\HorseMenPic\HorseMenPic.prg
File:	..\Parts\FacetSkull\data\FacetSkull.kla														d800	232a	03e8
File:	..\Parts\FacetSkull\data\FacetSkull.kla*													dc00	1f42	03e8
File:	..\Parts\FacetSkull\data\FacetSkull.kla														e000	0002	0600

;Bundle #0f
File:	..\..\Out\6502\Parts\CircleScroller\CircleScroller.prg
File:	..\..\Out\6502\Parts\CircleScroller\FontShifted.bin											b000
File:	..\Parts\CircleScroller\Data\TurnDiskSprites.map*											d000

;Bundle #10
File:	..\..\Out\6502\Parts\CircleScroller\circle.scr*												dc00
File:	..\..\Out\6502\Parts\CircleScroller\ScrollText.bin											c000
File:	..\Parts\CircleScroller\Data\BKG.map														e000

New Disk

Path:	..\..\D64\MementoMori-Disk3.d64
Header:	Memento Mori 3
ID:		-G*P-
Name:	Memento Mori/G*P
Start:	ff40
DirArt:	Data\directory_art_03.d64
IL0:	8
IL1:	4

;Bundle #00
File:	..\..\Out\6502\Main\Entry.prg
File:	..\..\Out\6502\Main\Main-BaseCode.prg
File:	..\..\Out\6502\Main\DISK-MementoMori-C.prg

;Bundle #01
File:	..\..\Out\6502\Parts\Quote\Quote.prg
File:	..\..\Out\6502\Parts\Quote\Quote.imap														a000
File:	..\..\Out\6502\Parts\Quote\Quote.iscr														a800

;Bundle #02
File:	..\..\Out\6502\Parts\VerticalSideBorderBitmap\VerticalSideBorderBitmap.prg
File:	..\..\Out\6502\55Data.bin																	8800	00000	0400
File:	..\..\Out\6502\00Data.bin																	8c00	00000	0400
File:	..\..\Out\6502\NibbleLookup.bin																9f00
File:	..\..\Out\6502\FFData.bin																	be00	00000	01c0
File:	..\..\Out\6502\55Data.bin																	c000	00000	0c00
File:	..\..\Out\6502\00Data.bin																	cc00	00000	0400
File:	..\..\Out\6502\FFData.bin																	e000	00000	1fc0

;Bundle #03 - Place holder, to push the first stream data block to the right T:S (5:19), will be skipped during loading
File:	..\..\Out\6502\Parts\VerticalSideBorderBitmap\StreamData.bin								9000	10000	0b00

;Bundle #04
File:	..\..\Out\6502\00Data.bin																	d800	00000	03e8

Align	;Bundles
Script:	..\..\Out\6502\Main\VerticalSideBorderBitmap-StreamData.sls

;Bundle #2c
File:	..\Music\Xiny6581-Carbondioxide.sid
