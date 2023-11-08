[Sparkle Loader Script]

Path:	..\..\D64\TheSantas-A.d64
Header:	   The Santas
ID:		disk1
Name:	 Xmas Megademo! 
Start:	ff40
DirArt:	Data\TheSantas_dir_art_01.d64
IL0:	7
IL1:	4

File:	..\..\Out\6502\Main\Entry-Side1.prg

File:	..\..\Out\6502\Main\Main-BaseCode.prg
File:	..\Music\Mibri-Santas.sid

'Walt's Basic Wipe + Letter - Preload: $2000-$4000, $c000-$ffff
File:	..\..\Out\6502\Parts\WaltBasicWipe\DISK-WaltBasicWipe.prg
File:	..\Parts\WaltBasicWipe\Wipe_Code.prg
File:	..\Parts\WaltBasicWipe\Wipe_Data.prg
File:	..\Parts\WaltLetter\Letter_Bitmap.prg
File:	..\Parts\WaltLetter\Letter_MainCode.prg
File:	..\Parts\WaltLetter\Letter_ScreenData.prg
File:	..\Parts\WaltLetter\Letter_Sprites.prg
File:	..\Parts\WaltLetter\Letter_Tables.prg

'Walt's Letter driver code - could be merged with the Wipe driver code...
File:	..\..\Out\6502\Parts\WaltLetter\DISK-WaltLetter.prg

'Preload Preplex' Snow Carpet $2000-$4000 and $c000-$fff0 (to be relocated to $4000)
File:	..\Parts\PerplexSnow\PerplexSnow.prg
File:	..\Parts\PerplexSnow\Data\ltrans.bin
File:	..\Parts\PerplexSnow\Data\pic.koa														382f	0002	07d1
File:	..\Parts\PerplexSnow\Data\pic.koa*														c000	07d3
File:	..\Parts\PerplexSnow\Data\snow.bin														e000	0002

'Perplex' Snow Carpet, free mem: $2e00-$3600, $7500-$7c00, ($9db0-$a000), $c000-$ffff
File:	..\..\Out\6502\Parts\PerplexSnow\DISK-PerplexSnow.prg
File:	..\Parts\PerplexSnow\Data\fadecode.bin
File:	..\Parts\PerplexSnow\Data\Logo-1.bin

'Logos for the Snow Carpet
Script:	..\Parts\PerplexSnow\PerplexSnowLogos.sls

'Preloading Leuat's Rotating Santas (uses $2000-$f800) and some of Raistlin's Produly Presents (f800-)
File:	..\Parts\LeuatRotatingSantas\LeuatRotatingSantas.prg									2e00	0e02	0800
File:	..\Parts\LeuatRotatingSantas\LeuatRotatingSantas.prg									7500	5502	0700
File:	..\Parts\LeuatRotatingSantas\LeuatRotatingSantas.prg									c000	a002	1000
File:	..\Parts\LeuatRotatingSantas\LeuatRotatingSantas.prg									e000	c002
File:	..\..\Out\6502\Parts\ProudlyPresent\ProudlyPresent-Screens.bin							f800

'Raster fader: white -> black
File:	..\..\Out\6502\Parts\RasterFader\DISK-RasterFader.prg
File:	..\..\Out\6502\Parts\RasterFader\RasterFaderDown.prg

'More preloading of Leuat's Rotating Santas
File:	..\Parts\LeuatRotatingSantas\LeuatRotatingSantas.prg									2000	0002	0e00
File:	..\Parts\LeuatRotatingSantas\LeuatRotatingSantas.prg									3600	1602	3f00
File:	..\Parts\LeuatRotatingSantas\LeuatRotatingSantas.prg									7c00	5c02	4400
File:	..\Parts\LeuatRotatingSantas\LeuatRotatingSantas.prg*									d000	b002	1000

'Finishing Leuat's Rotating Santas
File:	..\..\Out\6502\Parts\LeuatRotatingSantas\DISK-LeuatRotatingSantas.prg

'Proudly Present by JonEgg and Raistlin
File:	..\..\Out\6502\Parts\ProudlyPresent\DISK-ProudlyPresent.prg
File:	..\..\Out\6502\Parts\ProudlyPresent\ProudlyPresent.prg
File:	..\..\Out\6502\Parts\ProudlyPresent\ProudlyPresent.map*									c000
File:	..\Parts\ProudlyPresent\Data\Snowfall.map												f400
File:	..\..\Out\6502\Parts\ProudlyPresent\SineTable.bin										ff00

'Preloading Raistlin's TechTech
File:	..\..\Out\6502\Parts\TechTechTree\TechTechTree.prg
File:	..\..\Out\6502\Parts\TechTechTree\SinTables.bin											9d00
File:	..\..\Out\6502\Parts\TechTechTree\Bitmap.map											2000	0000	1bbf
File:	..\..\Out\6502\Parts\TechTechTree\sprites.map											8000

'Rest of Raistlin's Tech Tech
File:	..\..\Out\6502\Parts\TechTechTree\DISK-TechTechTree.prg
File:	..\..\Out\6502\Parts\TechTechTree\Bitmap.scr											0400	0000	03bf

'Walt's Transition light gray ->white
File:	..\..\Out\6502\Parts\WaltTrans\DISK-WaltTrans.prg
File:	..\Parts\WaltTrans\WaltTrans_Code.prg

'Preloading Qzerow's Xmastree
File:	..\Parts\QzerowXmastree\QzerowXmastree.prg

'Driver code for Qzerow's Xmastree
File:	..\..\Out\6502\Parts\QzerowXmastree\DISK-QzerowXmastree.prg

'Preloading Qzerow's Yellow Snow
File:	..\Parts\QzerowYellowSnow\QzerowYellowSnow.prg
File:	..\Parts\QzerowYellowSnow\QzerowYellowSnowSprites.prg*

'Finishing Qzerow's Yellow Snow - leaves $2000-$4c00, $ba00-$cc00, $d000-$e000 untouched
File:	..\..\Out\6502\Parts\QzerowYellowSnow\DISK-QzerowYellowSnow.prg
'File:	..\Parts\QzerowYellowSnow\QzerowYellowSnow.prg											2000	0002	3fc0

'Preloading Christmas Ball 2000-4a00 c100-cc00
File:	..\..\Out\6502\Parts\ChristmasBall\ChristmasBall.prg									2000	0002	2a00
File:	..\..\6502\Parts\ChristmasBall\Data\BKG.kla												c100	0102	0b00

Raster fader: white -> black
File:	..\..\Out\6502\Parts\RasterFader\DISK-RasterFader.prg
File:	..\..\Out\6502\Parts\RasterFader\RasterFaderUp.prg

'More preloading of the Christmas Ball part
File:	..\..\Out\6502\Parts\ChristmasBall\ChristmasBall.prg									4a00	2a02
File:	..\..\Out\6502\Parts\ChristmasBall\ColourFades.bin										b700
File:	..\..\Out\6502\Parts\ChristmasBall\TopSinTables.bin										b800
File:	..\..\Out\6502\Parts\ChristmasBall\BottomSinTables.bin									bc00
File:	..\..\6502\Parts\ChristmasBall\Data\BKG.kla												c000	0002	0100
File:	..\..\6502\Parts\ChristmasBall\Data\BKG.kla*											cc00	0c02	1340
File:	..\..\6502\Parts\ChristmasBall\Data\HISprites0.map										e400
File:	..\..\6502\Parts\ChristmasBall\Data\HISprites1.map										e480
File:	..\..\6502\Parts\ChristmasBall\Data\MCSprites0.map										e580
File:	..\..\6502\Parts\ChristmasBall\Data\MCSprites1.map										e640
File:	..\..\6502\Parts\ChristmasBall\Data\MCSprites2.map										e7c0
File:	..\..\6502\Parts\ChristmasBall\Data\BKG.kla												f000	1f42	03e8
File:	..\..\6502\Parts\ChristmasBall\Data\BKG.kla												f400	232a	03e8

'Driver code for the Christmas Ball part
File:	..\..\Out\6502\Parts\ChristmasBall\DISK-ChristmasBall.prg

'Xiny6581 - Mices Christmas Nip SID - separate bundle!!!
File:	..\Music\Xiny6581-MicesChristmasNip.sid

'----------------------------------------------------------------------------------------------------------------------------------------

'New Disk - Disk 2

'----------------------------------------------------------------------------------------------------------------------------------------

Path:	..\..\D64\TheSantas-B.d64
Header:	   The Santas
ID:		disk2
Name:	 Xmas Megademo! 
Start:	ff40
DirArt:	Data\TheSantas_dir_art_02.d64
IL0:	8
IL1:	6
IL2:	6

'Bundle #00
File:	..\..\Out\6502\Main\Entry-WithDigiNoSID.prg

'Bundle #01
File:	..\..\Out\6502\Main\Main-BaseCode.prg
File:	..\Music\Drax-RockingAround.sid

'Bundle #02 - Traps Digi
File:	..\..\Out\6502\Parts\TrapDigiLamer\TrapDigiLamer.prg
File:	..\Parts\TrapDigiLamer\Data\TrapDigiLamer.bin											2100

'Bundle #03 - Visage's Diagonal MC Scroller
File:	..\..\Out\6502\Parts\VisageMCScroller\DISK-VisageMCScroller.prg
File:	..\Parts\TrapXmasDiagFader\TrapXmasDiagStart.prg

'Bundles #04-#52
Script:	..\Parts\VisageMCScroller\VisageMCScrollerInclude.sls

'Bundle #53 - Preloading Fade-out (one before the last loader call in diagscroller)
File:	..\..\Out\6502\Parts\TrapXmasDiagFader\TrapXmasDiagEnd.prg

'Bundle #54 - Preloading some of the Layer Part by Dr. Science (last loader call from diagscroller)
File:	..\Parts\DrScienceLayerPart\LayerPart_Segment5.prg										e000	1402

'Preload next SID while fading out DiagScroller
File:	..\Parts\DrScienceLayerPart\LayerPart_Segment5.prg*										cc00	0002	1400
File:	..\Music\Steel-Donky.sid																b000	007e

'Dr. Science's Layer Part
File:	..\..\Out\6502\Parts\DrScienceLayerPart\DISK-DrScienceLayerPart.prg
File:	..\Parts\DrScienceLayerPart\LayerPart_Segment1.prg
File:	..\Parts\DrScienceLayerPart\LayerPart_Segment4.prg

'Rest of Dr. Science's Layer Part
File:	..\Parts\DrScienceLayerPart\LayerPart_Segment2.prg
File:	..\Parts\DrScienceLayerPart\LayerPart_Segment3.prg

'Preloading Trap's Approved
File:	..\Parts\TrapApproved\TrapApproved.prg

'Driver code of Trap's Approved
File:	..\..\Out\6502\Parts\TrapApproved\DISK-TrapApproved.prg

'Preloading Trap's Xmas Balls
File:	..\Parts\TrapXmasballs\TrapXmasballs.prg												8000	6002
File:	..\Parts\TrapXmasballs\TrapXmasballs.prg												9800	0002	3800
File:	..\Music\Steel-ComingHome.sid															e000	007e

'Trap's Xmas Balls loads $2000-$87ba
File:	..\..\Out\6502\Parts\TrapXmasballs\DISK-TrapXmasballs.prg

'Data for the Xmas Balls part - loading handled by the part
File:	..\Parts\TrapXmasballs\LoadData.prg

'Walt's Candy Cane
File:	..\..\Out\6502\Parts\WaltCandy\DISK-WaltCandy.prg
File:	..\Parts\WaltCandy\Candy_Data.prg
File:	..\Parts\WaltCandy\Candy_GFX1.prg
File:	..\Parts\WaltCandy\Candy_GFX2.prg
File:	..\Parts\WaltCandy\Candy_MainCode.prg

'Preloading Qzerow's Bumpmas $2000-$4000
File:	..\Parts\QzerowBumpmas\QzerowBumpmas.prg												2000	0002	2000

'Load next SID
File:	..\..\Out\6502\Main\DISK-LoadSID.prg

'Xiny6581 - Mices Christmas Nip SID - separate bundle!!!
File:	..\Music\Xiny6581-TheLittleSugarBaker.sid

'Walt's Transition
'File:	..\..\Out\6502\Parts\WaltTrans\DISK-WaltTrans.prg
'File:	..\Parts\WaltTrans\WaltTrans_Code.prg
'
'Finishing Qzerow's Bumpmas
'File:	..\Parts\QzerowBumpmas\QzerowBumpmas.prg												4000	2002

'Qzerow's Bumpmas turndisk part
File:	..\..\Out\6502\Parts\QzerowBumpmas\DISK-QzerowBumpmas.prg
File:	..\Parts\QzerowBumpmas\QzerowBumpmas.prg												4000	2002

'----------------------------------------------------------------------------------------------------------------------------------------

'New Disk - Disk 3

'----------------------------------------------------------------------------------------------------------------------------------------

Path:	..\..\D64\TheSantas-C.d64
Header:	   The Santas
ID:		disk3
Name:	 Xmas Megademo! 
Start:	ff40
DirArt:	Data\TheSantas_dir_art_03.d64
IL0:	5
IL1:	4

'File:	..\..\Out\6502\Main\Entry-WithDigiNoSID.prg
'
'File:	..\..\Out\6502\Main\Main-BaseCode.prg
'File:	..\Music\Laxity-Rudolph.sid
'
''Walt's Basic Wipe + Letter - Preload: $2000-$4000, $c000-$ffff
'File:	..\..\Out\6502\Parts\WaltBasicWipe\DISK-WaltBasicWipe_NoMusic.prg
'File:	..\Parts\WaltBasicWipe\Wipe_Code_NoMusic.prg
'File:	..\Parts\WaltBasicWipe\Wipe_Data.prg

File:	..\..\Out\6502\Main\Entry-WithDigi.prg

File:	..\..\Out\6502\Main\Main-BaseCode.prg
File:	..\Music\Laxity-Rudolph.sid

'Trap's Digi
File:	..\..\Out\6502\Parts\TrapDigiLamer\TrapDigiLamer.prg
File:	..\Parts\TrapDigiLamer\Data\TrapDigiLamer.bin											2100

'Walt's HeartPicFader
File:	..\..\Out\6502\Parts\WaltHeartFader\DISK-WaltHeartFader.prg
File:	..\Parts\WaltHeartFader\HeartPic_Code.prg
File:	..\Parts\WaltHeartFader\HeartPic_IRQ.prg
File:	..\Parts\WaltHeartFader\HeartPic_Picture.prg

'Loading Leuat's scroller while Heart pic is fading in...
File:	..\Parts\LeuatScroller\LeuatScroller.prg												2000	0002	1100
File:	..\Parts\LeuatScroller\LeuatScroller.prg*												8000	6002

'Preloading some of Dr. Science's Jelly Box while Heat pic is fading out
File:	..\Parts\DrScienceBox\Box_Fader_Segment1.prg
File:	..\Parts\DrScienceBox\Box_Fader_Segment2.prg

'Dr. Science's Jelly Box
File:	..\..\Out\6502\Parts\DrScienceBox\DISK-DrScienceBox.prg
File:	..\Parts\DrScienceBox\Box_Fader_Segment3.prg

'Jelly Box Fade-out uses: $6a00-$6e00, $cd00-$d000, $fa00-$ff62
File:	..\Parts\DrScienceBox\Box_Main_Segment1.prg
File:	..\Parts\DrScienceBox\Box_Main_Segment2.prg
File:	..\Parts\DrScienceBox\Box_Main_Segment3.prg
File:	..\Parts\DrScienceBox\Box_Main_Segment4.prg

'Preloading Dr. Science's Text Displayer - can preload $3600-$ffff
File:	..\Parts\DrScienceTextDisplayer2\DrScienceTextDisplayer2.prg

'Finishing Dr. Science's TextDisplayer
File:	..\..\Out\6502\Parts\DrScienceTextDisplayer2\DISK-DrScienceTextDisplayer2.prg

'Preloading Shadow's Christmastree $3600-
File:	..\Parts\ShadowChristmastree\ShadowChristmastree.prg*									3600	1602

'Finsihing Shadow's Christmastree: $2000-$3600
File:	..\..\Out\6502\Parts\ShadowChristmastree\DISK-ShadowChristmastree.prg
File:	..\Parts\ShadowChristmastree\ShadowChristmastree.prg									2000	0002	1600	

'Strepto's Colorcycler
Script:	..\Parts\StreptoColorcycler\Cradle-include.sls

'Raster fader: blue $06 -> grey $0c
File:	..\..\Out\6502\Parts\RasterFader\DISK-RasterFader.prg
File:	..\..\Out\6502\Parts\RasterFader\RasterFaderUp.prg

'Preloading most of Raistlin's Greetings Scroller during the raster fade
File:	..\..\Out\6502\Parts\GreetingScroller\GreetingScroller.prg
File:	..\..\Out\6502\Parts\GreetingScroller\SpriteMaskData.bin								b800
File:	..\..\Out\6502\Parts\GreetingScroller\ScrollText.bin									c000
File:	..\..\Out\6502\Parts\GreetingScroller\BKG.scr											cc00
File:	..\..\Out\6502\Parts\GreetingScroller\StarSprites.map*									dc00
File:	..\..\Out\6502\Parts\GreetingScroller\BKG.map											e000

'Driver code of Raistlin's Greetings Scroller
File:	..\..\Out\6502\Parts\GreetingScroller\DISK-GreetingScroller.prg

'Remaining segments of the Greetings Scroller loaded during ease-in
File:	..\..\Out\6502\Parts\GreetingScroller\DrawShape.prg

'----------------------------------------------------------------------------------------------------------------------------------------

'New Disk - Disk 4

'----------------------------------------------------------------------------------------------------------------------------------------

Path:	..\..\D64\TheSantas-D.d64
Header:	   The Santas
ID:		disk4
Name:	 Xmas Megademo! 
Start:	ff40
DirArt:	Data\TheSantas_dir_art_04.d64
IL0:	5
IL1:	4

'File:	..\..\Out\6502\Main\Entry-WithDigiNoSID.prg
'
'File:	..\..\Out\6502\Main\Main-BaseCode.prg
'File:	..\Music\Vincenzo-Whammer.sid
'
''Walt's Basic Wipe + Letter - Preload: $2000-$4000, $c000-$ffff
'File:	..\..\Out\6502\Parts\WaltBasicWipe\DISK-WaltBasicWipe_NoMusic.prg
'File:	..\Parts\WaltBasicWipe\Wipe_Code_NoMusic.prg
'File:	..\Parts\WaltBasicWipe\Wipe_Data.prg

File:	..\..\Out\6502\Main\Entry-WithDigi.prg

File:	..\..\Out\6502\Main\Main-BaseCode.prg
File:	..\Music\Vincenzo-Whammer.sid

'Trap's Digi
File:	..\..\Out\6502\Parts\TrapDigiLamer\TrapDigiLamer.prg
File:	..\Parts\TrapDigiLamer\Data\TrapDigiLamer.bin											2100

'Qzerow's Sledge Fader - can preload to	$2000-$3500 and $6000-
File:	..\..\Out\6502\Parts\QzerowSledgeFade\DISK-QzerowSledgeFade.prg
File:	..\Parts\QzerowSledgeFade\QzerowSledgeFade.prg
File:	..\Parts\QzerowSledgeFade\Data\bitmap.col												7000
File:	..\Parts\QzerowSledgeFade\Data\bitmap.map												7400

'Preloading Dr Science's Text Displayer $c600-d000 and $e000-$f400
File:	..\Parts\DrScienceTextDisplayer\DrScienceTextDisplayer_File1.prg
File:	..\Parts\DrScienceTextDisplayer\DrScienceTextDisplayer_File2.prg

'Dr. Science's Text Displayer - can preload to $3600-$ffff
File:	..\..\Out\6502\Parts\DrScienceTextDisplayer\DISK-DrScienceTextDisplayer.prg

'Preload Leuat's Muscle Santa - $3600-
'File:	..\Parts\LeuatXmasFader\LeuatXmasFader.prg												3600	1602
File:	..\Parts\LeuatXmasFader\LeuatXmasFader.prg
File:	..\Parts\DrScienceToplessSanta\Topless_Fader_Segm1.prg
File:	..\Parts\DrScienceToplessSanta\Topless_Segment1_Up.prg
'File:	..\Parts\DrScienceToplessSanta\Topless_Segment2_Up.prg

'Rest of Leuat's Xmastree Fader and Muscle Santa - $2000-$3600 + Dr. Sciences' Topless Fader
File:	..\..\Out\6502\Parts\LeuatXmasFader\DISK-LeuatXmasFader.prg
'File:	..\Parts\LeuatXmasFader\LeuatXmasFader.prg												2000	0002	1600
'File:	..\Parts\DrScienceToplessSanta\Topless_Fader_Segm1.prg

'Dr. Science's Topless Santa
'File:	..\Parts\DrScienceToplessSanta\Topless_Segment1.prg
'File:	..\Parts\DrScienceToplessSanta\Topless_Segment1_Up.prg
'File:	..\Parts\DrScienceToplessSanta\Topless_Segment2_Up.prg

'Walt's Transition
File:	..\..\Out\6502\Parts\WaltTrans\DISK-WaltTrans.prg
File:	..\Parts\WaltTrans\WaltTrans_Code.prg

Preloading Marching Snowflakes Part 1
File:	..\..\Out\6502\Parts\MarchingSnowflakes1\MarchingSnowflakes1.prg
File:	..\..\6502\Parts\MarchingSnowflakes1\Data\Sprites.map									22c0

'Sparta's Marching Snowflakes Part 1
File:	..\..\Out\6502\Parts\MarchingSnowflakes1\DISK-MarchingSnowflakes1.prg

'Most of Sparta's Snowflake Zoomer
Script:	..\..\6502\Parts\SnowflakeZoomer\SnowflakeZoomerScript.sls

'Rest of Sparta's Snowflake Zoomer
File:	..\..\Out\6502\Parts\SnowflakeZoomer\DISK-SnowflakeZoomer.prg
File:	..\..\6502\Parts\SnowflakeZoomer\Data\Bitmap.kla										d800	232a	03e8

'Sparta's Marching Snowflakes Part 2
File:	..\..\Out\6502\Parts\MarchingSnowflakes2\MarchingSnowflakes2.prg
File:	..\..\6502\Parts\MarchingSnowflakes2\Data\Sprites.map									22c0

'Driver code of Marching Snowflakes Part 2
File:	..\..\Out\6502\Parts\MarchingSnowflakes2\DISK-MarchingSnowflakes2.prg

'Driver code for Ego's Raytracer and Raster fader: dark blue -> light gray
File:	..\..\Out\6502\Parts\EgoRaytrace\DISK-EgoRaytrace.prg
File:	..\..\Out\6502\Parts\RasterFader\RasterFaderUp.prg

'Ego's Raytracer
Script:	..\Parts\EgoRaytrace\EgoRaytraceInclude.sls

'Traps' 2021 Preload
File:	..\Parts\Trap2021\Main.bin																9000

'Load next SID
File:	..\..\Out\6502\Main\DISK-LoadSID.prg

'Xiny6581 - The Dark Serpentine SID - separate bundle!!!
File:	..\Music\Xiny6581-TheDarkSerpentine.sid

'Traps' 2021
File:	..\..\Out\6502\Parts\Trap2021\DISK-Trap2021.prg
File:	..\Parts\Trap2021\Graphics.bin															4000

'EndOfDisk
File:	..\..\Out\6502\Main\DISK-EndWithLoop.prg
