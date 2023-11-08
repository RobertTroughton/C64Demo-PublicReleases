#define macros
DIR_EXTRAS = ..\extras
DIR_SPARKLE = $(DIR_EXTRAS)\Sparkle
SPARKLE = $(DIR_SPARKLE)\Sparkle2.exe
DIR_KICKASS = $(DIR_EXTRAS)\KickAss
KICKASS = Java -jar $(DIR_KICKASS)\KickAss.jar
DIR_BASS = $(DIR_EXTRAS)\Bass
BASS = $(DIR_BASS)\Bass.exe
DIR_ZIP = $(DIR_EXTRAS)\Zip
ZIP = $(DIR_ZIP)\zip.exe -j -X
STRIPZIP = $(DIR_ZIP)\stripzip.exe

..\D64\TheSantas-A.d64: Main\TheSantas.sls Parts\SnowflakeZoomer\SnowflakeZoomerScript.sls Music\Mibri-Santas.sid Music\Xiny6581-MicesChristmasNip.sid Music\Drax-RockingAround.sid Music\Steel-Donky.sid Music\Steel-ComingHome.sid Music\Xiny6581-TheLittleSugarBaker.sid Music\Laxity-Rudolph.sid Music\Vincenzo-Whammer.sid Music\Xiny6581-TheDarkSerpentine.sid ..\Out\6502\Main\DISK-EndOfDisk.prg ..\Out\6502\Main\DISK-EndWithLoop.prg ..\Out\6502\Main\DISK-LoadSID.prg ..\Out\6502\Main\DISK-NextSide.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Entry-Side1.prg ..\Out\6502\Main\Entry-WithDigi.prg ..\Out\6502\Main\Entry-WithDigiNoSID.prg ..\D64\RasterFaderUp.d64 ..\D64\RasterFaderDown.d64 ..\Out\6502\Parts\TrapDigiLamer\TrapDigiLamer.prg ..\D64\ChristmasBall.d64 ..\D64\GreetingScroller.d64 ..\D64\SnowflakeZoomer.d64 ..\D64\Leuat-Doc-ToplessSanta.d64 ..\D64\EgoRaytrace.d64 ..\D64\MarchingSnowflakes1.d64 ..\D64\MarchingSnowflakes2.d64 ..\D64\LeuatRotatingSantas.d64 ..\D64\DrScienceBox.d64 ..\D64\TechTechTree.d64 ..\D64\VisageMCScroller.d64 ..\D64\DrScienceLayerPart.d64 ..\D64\QzerowXmastree.d64 ..\D64\TrapXmasballs.d64 ..\D64\WaltCandy.d64 ..\D64\LeuatScroller.d64 ..\D64\TrapApproved.d64 ..\D64\PerplexSnow.d64 ..\D64\ShadowChristmastree.d64 ..\D64\StreptoColorcycler.d64 ..\D64\Trap2021.d64 ..\D64\WaltLetter.d64 ..\D64\QzerowYellowSnow.d64 ..\D64\WaltBasicWipe.d64 ..\D64\QzerowBumpmas.d64 ..\D64\DrScienceTextDisplayer.d64 ..\D64\DrScienceTextDisplayer2.d64 ..\D64\WaltHeartFader.d64 ..\D64\ProudlyPresent.d64 ..\D64\QzerowSledgeFade.d64 ..\D64\WaltTrans.d64
	$(SPARKLE) Main\TheSantas.sls
	$(ZIP) ..\D64\TheSantas.zip ..\D64\TheSantas-A.d64 ..\D64\TheSantas-B.d64 ..\D64\TheSantas-C.d64 ..\D64\TheSantas-D.d64
	$(STRIPZIP) ..\D64\TheSantas.zip

..\Out\6502\Main\Main-BaseCode.prg: Main\Main-BaseCode.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Main\Main-BaseCode.asm -odir ..\..\Out\6502\Main

..\Out\6502\Main\Entry.prg: Main\Entry.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Main\Main-BaseCode.prg
	$(KICKASS) Main\Entry.asm -odir ..\..\Out\6502\Main

..\Out\6502\Main\Entry-Side1.prg: Main\Entry-Side1.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Main\Main-BaseCode.prg
	$(KICKASS) Main\Entry-Side1.asm -odir ..\..\Out\6502\Main
	
..\Out\6502\Main\Entry-WithDigi.prg: Main\Entry-WithDigi.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Main\Main-BaseCode.prg
	$(KICKASS) Main\Entry-WithDigi.asm -odir ..\..\Out\6502\Main
	
..\Out\6502\Main\Entry-WithDigiNoSID.prg: Main\Entry-WithDigiNoSID.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Main\Main-BaseCode.prg
	$(KICKASS) Main\Entry-WithDigiNoSID.asm -odir ..\..\Out\6502\Main

..\Out\6502\Main\DISK-EndOfDisk.prg: Main\DISK-EndOfDisk.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Main\Main-BaseCode.prg
	$(KICKASS) Main\DISK-EndOfDisk.asm -odir ..\..\Out\6502\Main

..\Out\6502\Main\DISK-LoadSID.prg: Main\DISK-LoadSID.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Main\Main-BaseCode.prg
	$(KICKASS) Main\DISK-LoadSID.asm -odir ..\..\Out\6502\Main

..\Out\6502\Main\DISK-EndWithLoop.prg: Main\DISK-EndWithLoop.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Main\Main-BaseCode.prg
	$(KICKASS) Main\DISK-EndWithLoop.asm -odir ..\..\Out\6502\Main

..\Out\6502\Main\DISK-NextSide.prg: Main\DISK-NextSide.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Main\Main-BaseCode.prg
	$(KICKASS) Main\DISK-NextSide.asm -odir ..\..\Out\6502\Main

..\Out\6502\Parts\TrapDigiLamer\TrapDigiLamer.prg: Parts\TrapDigiLamer\TrapDigiLamer.asm Parts\TrapDigiLamer\Data\TrapDigiLamer.bin Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Main\Main-BaseCode.prg
	$(KICKASS) Parts\TrapDigiLamer\TrapDigiLamer.asm -odir ..\..\..\Out\6502\Parts\TrapDigiLamer


 
..\D64\ProudlyPresent.d64: Parts\ProudlyPresent\ProudlyPresent.sls Music\Mibri-Santas.sid ..\Out\6502\Parts\ProudlyPresent\ProudlyPresent.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\ChristmasBall\DISK-ChristmasBall.prg ..\Out\6502\Main\DISK-EndOfDisk.prg ..\Out\6502\Parts\ProudlyPresent\SineTable.bin
	$(SPARKLE) Parts\ProudlyPresent\ProudlyPresent.sls

..\Out\6502\Parts\ProudlyPresent\ProudlyPresent.prg: Parts\ProudlyPresent\ProudlyPresent.asm ..\Out\6502\Parts\ProudlyPresent\DISK-ProudlyPresent.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\ProudlyPresent\ProudlyPresent.asm -odir ..\..\..\Out\6502\Parts\ProudlyPresent

..\Out\6502\Parts\ProudlyPresent\DISK-ProudlyPresent.prg: Parts\ProudlyPresent\DISK-ProudlyPresent.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\ProudlyPresent\DISK-ProudlyPresent.asm -odir ..\..\..\Out\6502\Parts\ProudlyPresent



..\D64\ChristmasBall.d64: Parts\ChristmasBall\ChristmasBall.sls Music\Mibri-Santas.sid ..\Out\6502\Parts\ChristmasBall\ChristmasBall.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\ChristmasBall\DISK-ChristmasBall.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\ChristmasBall\ChristmasBall.sls

..\Out\6502\Parts\ChristmasBall\ChristmasBall.prg: Parts\ChristmasBall\ChristmasBall.asm ..\Out\6502\Parts\ChristmasBall\BlitSprite.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\ChristmasBall\ChristmasBall.asm -odir ..\..\..\Out\6502\Parts\ChristmasBall

..\Out\6502\Parts\ChristmasBall\DISK-ChristmasBall.prg: Parts\ChristmasBall\DISK-ChristmasBall.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\ChristmasBall\DISK-ChristmasBall.asm -odir ..\..\..\Out\6502\Parts\ChristmasBall



..\D64\GreetingScroller.d64: Parts\GreetingScroller\GreetingScroller.sls Music\Mibri-Santas.sid ..\Out\6502\Parts\GreetingScroller\DrawShape.prg ..\Out\6502\Parts\GreetingScroller\GreetingScroller.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\GreetingScroller\DISK-GreetingScroller.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\GreetingScroller\GreetingScroller.sls

..\Out\6502\Parts\GreetingScroller\DrawShape.prg: Parts\GreetingScroller\GreetingScroller.asm ..\Out\6502\Parts\GreetingScroller\DrawShape.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) ..\Out\6502\Parts\GreetingScroller\DrawShape.asm -symbolfile

..\Out\6502\Parts\GreetingScroller\GreetingScroller.prg: Parts\GreetingScroller\GreetingScroller.asm ..\Out\6502\Parts\GreetingScroller\DrawShape.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\GreetingScroller\GreetingScroller.asm -odir ..\..\..\Out\6502\Parts\GreetingScroller

..\Out\6502\Parts\GreetingScroller\DISK-GreetingScroller.prg: Parts\GreetingScroller\DISK-GreetingScroller.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\GreetingScroller\DISK-GreetingScroller.asm -odir ..\..\..\Out\6502\Parts\GreetingScroller



..\D64\SnowflakeZoomer.d64: Parts\SnowflakeZoomer\SnowflakeZoomer.sls Music\Mibri-Santas.sid ..\Out\6502\Parts\SnowflakeZoomer\SnowflakeZoomer.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\SnowflakeZoomer\DISK-SnowflakeZoomer.prg Parts\SnowflakeZoomer\Data\Bitmap.kla ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\SnowflakeZoomer\SnowflakeZoomer.sls

..\Out\6502\Parts\SnowflakeZoomer\SnowflakeZoomer.prg: Parts\SnowflakeZoomer\SnowflakeZoomer.asm Parts\SnowflakeZoomer\Data\BitTab.bin Parts\SnowflakeZoomer\Data\JmpTab.bin Parts\SnowflakeZoomer\Data\OffsetTab.bin Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\SnowflakeZoomer\SnowflakeZoomer.asm -odir ..\..\..\Out\6502\Parts\SnowflakeZoomer

..\Out\6502\Parts\SnowflakeZoomer\DISK-SnowflakeZoomer.prg: Parts\SnowflakeZoomer\DISK-SnowflakeZoomer.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\SnowflakeZoomer\DISK-SnowflakeZoomer.asm -odir ..\..\..\Out\6502\Parts\SnowflakeZoomer



..\D64\LeuatScroller.d64: Parts\LeuatScroller\LeuatScroller.sls Music\Mibri-Santas.sid Parts\LeuatScroller\LeuatScroller.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\LeuatScroller\DISK-LeuatScroller.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\LeuatScroller\LeuatScroller.sls

..\Out\6502\Parts\LeuatScroller\DISK-LeuatScroller.prg: Parts\LeuatScroller\DISK-LeuatScroller.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\LeuatScroller\DISK-LeuatScroller.asm -odir ..\..\..\Out\6502\Parts\LeuatScroller



..\D64\TrapApproved.d64: Parts\TrapApproved\TrapApproved.sls Music\Mibri-Santas.sid Parts\TrapApproved\TrapApproved.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\TrapApproved\DISK-TrapApproved.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\TrapApproved\TrapApproved.sls

..\Out\6502\Parts\TrapApproved\DISK-TrapApproved.prg: Parts\TrapApproved\DISK-TrapApproved.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\TrapApproved\DISK-TrapApproved.asm -odir ..\..\..\Out\6502\Parts\TrapApproved



..\D64\Leuat-Doc-ToplessSanta.d64: Parts\LeuatXmasFader\LeuatXmasFader.sls Music\Mibri-Santas.sid Parts\LeuatXmasFader\LeuatXmasFader.prg Parts\DrScienceToplessSanta\Topless_Fader_segm1.prg Parts\DrScienceToplessSanta\Topless_Segment1_Up.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\LeuatXmasFader\DISK-LeuatXmasFader.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\LeuatXmasFader\LeuatXmasFader.sls

..\Out\6502\Parts\LeuatXmasFader\DISK-LeuatXmasFader.prg: Parts\LeuatXmasFader\DISK-LeuatXmasFader.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\LeuatXmasFader\DISK-LeuatXmasFader.asm -odir ..\..\..\Out\6502\Parts\LeuatXmasFader



..\D64\RasterFaderUp.d64: Parts\RasterFader\RasterFaderUp.sls Music\Laxity-Rudolph.sid ..\Out\6502\Parts\RasterFader\RasterFaderUp.prg ..\Out\6502\Parts\RasterFader\DISK-RasterFader.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\RasterFader\RasterFaderUp.sls

..\Out\6502\Parts\RasterFader\RasterFaderUp.prg: Parts\RasterFader\RasterFaderUp.asm Parts\RasterFader\Data\RasterTab.bin Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\RasterFader\RasterFaderUp.asm -odir ..\..\..\Out\6502\Parts\RasterFader

..\D64\RasterFaderDown.d64: Parts\RasterFader\RasterFaderDown.sls Music\Laxity-Rudolph.sid ..\Out\6502\Parts\RasterFader\RasterFaderDown.prg ..\Out\6502\Parts\RasterFader\DISK-RasterFader.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\RasterFader\RasterFaderDown.sls

..\Out\6502\Parts\RasterFader\RasterFaderDown.prg: Parts\RasterFader\RasterFaderDown.asm Parts\RasterFader\Data\RasterTab.bin Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\RasterFader\RasterFaderDown.asm -odir ..\..\..\Out\6502\Parts\RasterFader

..\Out\6502\Parts\RasterFader\DISK-RasterFader.prg: Parts\RasterFader\DISK-RasterFader.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\RasterFader\DISK-RasterFader.asm -odir ..\..\..\Out\6502\Parts\RasterFader




..\D64\EgoRaytrace.d64: Parts\EgoRaytrace\EgoRaytrace.sls Parts\EgoRaytrace\EgoRaytraceInclude.sls Music\Mibri-Santas.sid Parts\EgoRaytrace\raytrace.bin Parts\EgoRaytrace\raytrace_bmp.bin Parts\EgoRaytrace\raytrace.dat Parts\EgoRaytrace\sprite_in.dat Parts\EgoRaytrace\sprite_move.dat ..\Out\6502\Parts\EgoRaytrace\DISK-EgoRaytrace.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\EgoRaytrace\EgoRaytrace.sls

..\Out\6502\Parts\EgoRaytrace\DISK-EgoRaytrace.prg: Parts\EgoRaytrace\DISK-EgoRaytrace.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\EgoRaytrace\DISK-EgoRaytrace.asm -odir ..\..\..\Out\6502\Parts\EgoRaytrace



..\D64\MarchingSnowflakes1.d64: Parts\MarchingSnowflakes1\MarchingSnowflakes1.sls Music\Mibri-Santas.sid ..\Out\6502\Parts\MarchingSnowflakes1\MarchingSnowflakes1.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\MarchingSnowflakes1\DISK-MarchingSnowflakes1.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\MarchingSnowflakes1\MarchingSnowflakes1.sls

..\Out\6502\Parts\MarchingSnowflakes1\MarchingSnowflakes1.prg: Parts\MarchingSnowflakes1\MarchingSnowflakes1.asm Parts\MarchingSnowflakes1\Data\Sprites.map Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\MarchingSnowflakes1\MarchingSnowflakes1.asm -odir ..\..\..\Out\6502\Parts\MarchingSnowflakes1

..\Out\6502\Parts\MarchingSnowflakes1\DISK-MarchingSnowflakes1.prg: Parts\MarchingSnowflakes1\DISK-MarchingSnowflakes1.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\MarchingSnowflakes1\DISK-MarchingSnowflakes1.asm -odir ..\..\..\Out\6502\Parts\MarchingSnowflakes1



..\D64\MarchingSnowflakes2.d64: Parts\MarchingSnowflakes2\MarchingSnowflakes2.sls Music\Mibri-Santas.sid ..\Out\6502\Parts\MarchingSnowflakes2\MarchingSnowflakes2.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\MarchingSnowflakes2\DISK-MarchingSnowflakes2.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\MarchingSnowflakes2\MarchingSnowflakes2.sls

..\Out\6502\Parts\MarchingSnowflakes2\MarchingSnowflakes2.prg: Parts\MarchingSnowflakes2\MarchingSnowflakes2.asm Parts\MarchingSnowflakes2\Data\Sprites.map Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\MarchingSnowflakes2\MarchingSnowflakes2.asm -odir ..\..\..\Out\6502\Parts\MarchingSnowflakes2

..\Out\6502\Parts\MarchingSnowflakes2\DISK-MarchingSnowflakes2.prg: Parts\MarchingSnowflakes2\DISK-MarchingSnowflakes2.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\MarchingSnowflakes2\DISK-MarchingSnowflakes2.asm -odir ..\..\..\Out\6502\Parts\MarchingSnowflakes2



..\D64\LeuatRotatingSantas.d64: Parts\LeuatRotatingSantas\LeuatRotatingSantas.sls Music\Vincenzo-Whammer.sid Parts\LeuatRotatingSantas\LeuatRotatingSantas.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\LeuatRotatingSantas\DISK-LeuatRotatingSantas.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\LeuatRotatingSantas\LeuatRotatingSantas.sls

..\Out\6502\Parts\LeuatRotatingSantas\DISK-LeuatRotatingSantas.prg: Parts\LeuatRotatingSantas\DISK-LeuatRotatingSantas.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\LeuatRotatingSantas\DISK-LeuatRotatingSantas.asm -odir ..\..\..\Out\6502\Parts\LeuatRotatingSantas



..\D64\DrScienceBox.d64: Parts\DrScienceBox\DrScienceBox.sls Music\Vincenzo-Whammer.sid Parts\DrScienceBox\Box_Fader_Segment1.prg Parts\DrScienceBox\Box_Fader_Segment2.prg Parts\DrScienceBox\Box_Fader_Segment3.prg Parts\DrScienceBox\Box_Main_Segment1.prg Parts\DrScienceBox\Box_Main_Segment2.prg Parts\DrScienceBox\Box_Main_Segment3.prg Parts\DrScienceBox\Box_Main_Segment4.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\DrScienceBox\DISK-DrScienceBox.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\DrScienceBox\DrScienceBox.sls

..\Out\6502\Parts\DrScienceBox\DISK-DrScienceBox.prg: Parts\DrScienceBox\DISK-DrScienceBox.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\DrScienceBox\DISK-DrScienceBox.asm -odir ..\..\..\Out\6502\Parts\DrScienceBox



..\D64\TechTechTree.d64: Parts\TechTechTree\TechTechTree.sls Music\Mibri-Santas.sid ..\Out\6502\Parts\TechTechTree\TechTechTree.prg ..\Out\6502\Parts\TechTechTree\SinTables.bin ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\TechTechTree\DISK-TechTechTree.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\TechTechTree\TechTechTree.sls

..\Out\6502\Parts\TechTechTree\TechTechTree.prg: Parts\TechTechTree\TechTechTree.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\TechTechTree\TechTechTree.asm -odir ..\..\..\Out\6502\Parts\TechTechTree

..\Out\6502\Parts\TechTechTree\DISK-TechTechTree.prg: Parts\TechTechTree\DISK-TechTechTree.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\TechTechTree\DISK-TechTechTree.asm -odir ..\..\..\Out\6502\Parts\TechTechTree



..\D64\VisageMCScroller.d64: Parts\VisageMCScroller\VisageMCScroller.sls Parts\VisageMCScroller\VisageMCScrollerInclude.sls Parts\VisageMCScroller\resources\Bank.bin Parts\VisageMCScroller\resources\bulkdata.txt Music\Vincenzo-Whammer.sid Parts\VisageMCScroller\code1.prg ..\Out\6502\Parts\TrapXmasDiagFader\TrapXmasDiagEnd.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\VisageMCScroller\DISK-VisageMCScroller.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\VisageMCScroller\VisageMCScroller.sls

..\Out\6502\Parts\VisageMCScroller\DISK-VisageMCScroller.prg: Parts\VisageMCScroller\DISK-VisageMCScroller.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\VisageMCScroller\DISK-VisageMCScroller.asm -odir ..\..\..\Out\6502\Parts\VisageMCScroller

..\Out\6502\Parts\TrapXmasDiagFader\TrapXmasDiagEnd.prg: Parts\TrapXmasDiagFader\TrapXmasDiagEnd.asm Parts\TrapXmasDiagFader\RasterTab.bin Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Main\Main-BaseCode.prg
	$(KICKASS) Parts\TrapXmasDiagFader\TrapXmasDiagEnd.asm -odir ..\..\..\Out\6502\Parts\TrapXmasDiagFader



..\D64\DrScienceLayerPart.d64: Parts\DrScienceLayerPart\DrScienceLayerPart.sls Music\Vincenzo-Whammer.sid Parts\DrScienceLayerPart\LayerPart_Segment1.prg Parts\DrScienceLayerPart\LayerPart_Segment2.prg Parts\DrScienceLayerPart\LayerPart_Segment3.prg Parts\DrScienceLayerPart\LayerPart_Segment4.prg Parts\DrScienceLayerPart\LayerPart_Segment5.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\DrScienceLayerPart\DISK-DrScienceLayerPart.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\DrScienceLayerPart\DrScienceLayerPart.sls

..\Out\6502\Parts\DrScienceLayerPart\DISK-DrScienceLayerPart.prg: Parts\DrScienceLayerPart\DISK-DrScienceLayerPart.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\DrScienceLayerPart\DISK-DrScienceLayerPart.asm -odir ..\..\..\Out\6502\Parts\DrScienceLayerPart



..\D64\DrScienceTextDisplayer.d64: Parts\DrScienceTextDisplayer\DrScienceTextDisplayer.sls Music\Vincenzo-Whammer.sid Parts\DrScienceTextDisplayer\DrScienceTextDisplayer_File1.prg Parts\DrScienceTextDisplayer\DrScienceTextDisplayer_File2.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\DrScienceTextDisplayer\DISK-DrScienceTextDisplayer.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\DrScienceTextDisplayer\DrScienceTextDisplayer.sls

..\Out\6502\Parts\DrScienceTextDisplayer\DISK-DrScienceTextDisplayer.prg: Parts\DrScienceTextDisplayer\DISK-DrScienceTextDisplayer.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\DrScienceTextDisplayer\DISK-DrScienceTextDisplayer.asm -odir ..\..\..\Out\6502\Parts\DrScienceTextDisplayer



..\D64\DrScienceTextDisplayer2.d64: Parts\DrScienceTextDisplayer2\DrScienceTextDisplayer2.sls Music\Vincenzo-Whammer.sid Parts\DrScienceTextDisplayer2\DrScienceTextDisplayer2.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\DrScienceTextDisplayer2\DISK-DrScienceTextDisplayer2.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\DrScienceTextDisplayer2\DrScienceTextDisplayer2.sls

..\Out\6502\Parts\DrScienceTextDisplayer2\DISK-DrScienceTextDisplayer2.prg: Parts\DrScienceTextDisplayer2\DISK-DrScienceTextDisplayer2.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\DrScienceTextDisplayer2\DISK-DrScienceTextDisplayer2.asm -odir ..\..\..\Out\6502\Parts\DrScienceTextDisplayer2



..\D64\QzerowXmastree.d64: Parts\QzerowXmastree\QzerowXmastree.sls Music\Vincenzo-Whammer.sid Parts\QzerowXmastree\QzerowXmastree.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\QzerowXmastree\DISK-QzerowXmastree.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\QzerowXmastree\QzerowXmastree.sls

..\Out\6502\Parts\QzerowXmastree\DISK-QzerowXmastree.prg: Parts\QzerowXmastree\DISK-QzerowXmastree.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\QzerowXmastree\DISK-QzerowXmastree.asm -odir ..\..\..\Out\6502\Parts\QzerowXmastree



..\D64\QzerowYellowSnow.d64: Parts\QzerowYellowSnow\QzerowYellowSnow.sls Music\Vincenzo-Whammer.sid Parts\QzerowYellowSnow\QzerowYellowSnow.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\QzerowYellowSnow\DISK-QzerowYellowSnow.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\QzerowYellowSnow\QzerowYellowSnow.sls

..\Out\6502\Parts\QzerowYellowSnow\DISK-QzerowYellowSnow.prg: Parts\QzerowYellowSnow\DISK-QzerowYellowSnow.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\QzerowYellowSnow\DISK-QzerowYellowSnow.asm -odir ..\..\..\Out\6502\Parts\QzerowYellowSnow



..\D64\QzerowSledgeFade.d64: Parts\QzerowSledgeFade\QzerowSledgeFade.sls Music\Vincenzo-Whammer.sid Parts\QzerowSledgeFade\QzerowSledgeFade.prg ..\Out\6502\Parts\QzerowSledgeFade\DISK-QzerowSledgeFade.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\QzerowSledgeFade\QzerowSledgeFade.sls

..\Out\6502\Parts\QzerowSledgeFade\DISK-QzerowSledgeFade.prg: Parts\QzerowSledgeFade\DISK-QzerowSledgeFade.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\QzerowSledgeFade\DISK-QzerowSledgeFade.asm -odir ..\..\..\Out\6502\Parts\QzerowSledgeFade



..\D64\QzerowBumpmas.d64: Parts\QzerowBumpmas\QzerowBumpmas.sls Music\Vincenzo-Whammer.sid Parts\QzerowBumpmas\QzerowBumpmas.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\QzerowBumpmas\DISK-QzerowBumpmas.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\QzerowBumpmas\QzerowBumpmas.sls

..\Out\6502\Parts\QzerowBumpmas\DISK-QzerowBumpmas.prg: Parts\QzerowBumpmas\DISK-QzerowBumpmas.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\QzerowBumpmas\DISK-QzerowBumpmas.asm -odir ..\..\..\Out\6502\Parts\QzerowBumpmas



..\D64\TrapXmasballs.d64: Parts\TrapXmasballs\TrapXmasballs.sls Music\Vincenzo-Whammer.sid Parts\TrapXmasballs\TrapXmasballs.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\TrapXmasballs\DISK-TrapXmasballs.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\TrapXmasballs\TrapXmasballs.sls

..\Out\6502\Parts\TrapXmasballs\DISK-TrapXmasballs.prg: Parts\TrapXmasballs\DISK-TrapXmasballs.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\TrapXmasballs\DISK-TrapXmasballs.asm -odir ..\..\..\Out\6502\Parts\TrapXmasballs



..\D64\WaltCandy.d64: Parts\WaltCandy\WaltCandy.sls Music\Vincenzo-Whammer.sid Parts\WaltCandy\Candy_Data.prg Parts\WaltCandy\Candy_GFX1.prg Parts\WaltCandy\Candy_GFX2.prg Parts\WaltCandy\Candy_MainCode.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\WaltCandy\DISK-WaltCandy.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\WaltCandy\WaltCandy.sls

..\Out\6502\Parts\WaltCandy\DISK-WaltCandy.prg: Parts\WaltCandy\DISK-WaltCandy.asm Parts\WaltCandy\Candy_HeaderCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\WaltCandy\DISK-WaltCandy.asm -odir ..\..\..\Out\6502\Parts\WaltCandy



..\D64\WaltLetter.d64: Parts\WaltLetter\WaltLetter.sls Music\Vincenzo-Whammer.sid ..\Out\6502\Parts\WaltLetter\DISK-WaltLetter.prg Parts\WaltLetter\Letter_Bitmap.prg Parts\WaltLetter\Letter_MainCode.prg Parts\WaltLetter\Letter_ScreenData.prg Parts\WaltLetter\Letter_Sprites.prg Parts\WaltLetter\Letter_Tables.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\WaltLetter\WaltLetter.sls

..\Out\6502\Parts\WaltLetter\DISK-WaltLetter.prg: Parts\WaltLetter\DISK-WaltLetter.asm Parts\WaltLetter\Letter_HeaderCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\WaltLetter\DISK-WaltLetter.asm -odir ..\..\..\Out\6502\Parts\WaltLetter



..\D64\WaltHeartFader.d64: Parts\WaltHeartFader\WaltHeartFader.sls Music\Vincenzo-Whammer.sid ..\Out\6502\Parts\WaltHeartFader\DISK-WaltHeartFader.prg Parts\WaltHeartFader\HeartPic_Code.prg Parts\WaltHeartFader\HeartPic_IRQ.prg Parts\WaltHeartFader\HeartPic_Picture.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\WaltHeartFader\WaltHeartFader.sls

..\Out\6502\Parts\WaltHeartFader\DISK-WaltHeartFader.prg: Parts\WaltHeartFader\DISK-WaltHeartFader.asm Parts\WaltHeartFader\HeartPic_HeaderCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\WaltHeartFader\DISK-WaltHeartFader.asm -odir ..\..\..\Out\6502\Parts\WaltHeartFader



..\D64\WaltBasicWipe.d64: Parts\WaltBasicWipe\WaltBasicWipe.sls Music\Mibri-Santas.sid ..\Out\6502\Parts\WaltBasicWipe\DISK-WaltBasicWipe.prg ..\Out\6502\Parts\WaltBasicWipe\DISK-WaltBasicWipe_NoMusic.prg Parts\WaltBasicWipe\Wipe_Code.prg Parts\WaltBasicWipe\Wipe_Data.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\WaltBasicWipe\WaltBasicWipe.sls

..\Out\6502\Parts\WaltBasicWipe\DISK-WaltBasicWipe.prg: Parts\WaltBasicWipe\DISK-WaltBasicWipe.asm Parts\WaltBasicWipe\Wipe_HeaderCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\WaltBasicWipe\DISK-WaltBasicWipe.asm -odir ..\..\..\Out\6502\Parts\WaltBasicWipe

..\Out\6502\Parts\WaltBasicWipe\DISK-WaltBasicWipe_NoMusic.prg: Parts\WaltBasicWipe\DISK-WaltBasicWipe_NoMusic.asm Parts\WaltBasicWipe\Wipe_HeaderCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\WaltBasicWipe\DISK-WaltBasicWipe_NoMusic.asm -odir ..\..\..\Out\6502\Parts\WaltBasicWipe



..\D64\PerplexSnow.d64: Parts\PerplexSnow\PerplexSnow.sls Parts\PerplexSnow\PerplexSnowLogos.sls ..\Out\6502\Parts\PerplexSnow\DISK-PerplexSnow.prg Parts\PerplexSnow\PerplexSnow.prg Parts\PerplexSnow\Data\fadecode.bin Parts\PerplexSnow\Data\logo-1.bin Parts\PerplexSnow\Data\logo-2.bin Parts\PerplexSnow\Data\logo-3.bin Parts\PerplexSnow\Data\logo-4.bin Parts\PerplexSnow\Data\logo-5.bin Parts\PerplexSnow\Data\snow.bin Parts\PerplexSnow\Data\ltrans.bin Parts\PerplexSnow\Data\pic.koa ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg Music\Vincenzo-Whammer.sid
	$(SPARKLE) Parts\PerplexSnow\PerplexSnow.sls

..\Out\6502\Parts\PerplexSnow\DISK-PerplexSnow.prg: Parts\PerplexSnow\DISK-PerplexSnow.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\PerplexSnow\DISK-PerplexSnow.asm -odir ..\..\..\Out\6502\Parts\PerplexSnow



..\D64\ShadowChristmastree.d64: Parts\ShadowChristmastree\ShadowChristmastree.sls Music\Mibri-Santas.sid Parts\ShadowChristmastree\ShadowChristmastree.prg ..\Out\6502\Parts\ShadowChristmastree\DISK-ShadowChristmastree.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\ShadowChristmastree\ShadowChristmastree.sls

..\Out\6502\Parts\ShadowChristmastree\DISK-ShadowChristmastree.prg: Parts\ShadowChristmastree\DISK-ShadowChristmastree.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\ShadowChristmastree\DISK-ShadowChristmastree.asm -odir ..\..\..\Out\6502\Parts\ShadowChristmastree
	


..\D64\StreptoColorcycler.d64: Parts\StreptoColorcycler\StreptoColorcycler.sls Music\Laxity-Rudolph.sid Parts\StreptoColorcycler\Cradle-include.sls Parts\StreptoColorcycler\Files\cradle.map Parts\StreptoColorcycler\Files\b1.prg Parts\StreptoColorcycler\Files\b2.prg Parts\StreptoColorcycler\Files\b3.prg Parts\StreptoColorcycler\Files\b4.prg Parts\StreptoColorcycler\Files\b5.prg Parts\StreptoColorcycler\Files\code1.prg Parts\StreptoColorcycler\Files\sprites.prg Parts\StreptoColorcycler\Files\cradle.scr  ..\Out\6502\Parts\StreptoColorcycler\DISK-StreptoColorcycler.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\StreptoColorcycler\StreptoColorcycler.sls

..\Out\6502\Parts\StreptoColorcycler\DISK-StreptoColorcycler.prg: Parts\StreptoColorcycler\DISK-StreptoColorcycler.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\StreptoColorcycler\DISK-StreptoColorcycler.asm -odir ..\..\..\Out\6502\Parts\StreptoColorcycler
	


..\D64\Trap2021.d64: Parts\Trap2021\Trap2021.sls Music\Laxity-Rudolph.sid Parts\Trap2021\Main.bin Parts\Trap2021\Graphics.bin ..\Out\6502\Parts\Trap2021\DISK-Trap2021.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\Trap2021\Trap2021.sls

..\Out\6502\Parts\Trap2021\DISK-Trap2021.prg: Parts\Trap2021\DISK-Trap2021.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\Trap2021\DISK-Trap2021.asm -odir ..\..\..\Out\6502\Parts\Trap2021
	


..\D64\WaltTrans.d64: Parts\WaltTrans\WaltTrans.sls Music\Laxity-Rudolph.sid Parts\WaltTrans\WaltTrans_Code.prg ..\Out\6502\Parts\WaltTrans\DISK-WaltTrans.prg ..\Out\6502\Parts\WaltTrans\DISK-WaltTransPreps.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\DISK-EndOfDisk.prg
	$(SPARKLE) Parts\WaltTrans\WaltTrans.sls

..\Out\6502\Parts\WaltTrans\DISK-WaltTrans.prg: Parts\WaltTrans\DISK-WaltTrans.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\WaltTrans\DISK-WaltTrans.asm -odir ..\..\..\Out\6502\Parts\WaltTrans

..\Out\6502\Parts\WaltTrans\DISK-WaltTransPreps.prg: Parts\WaltTrans\DISK-WaltTransPreps.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Main-BaseCode.asm
	$(KICKASS) Parts\WaltTrans\DISK-WaltTransPreps.asm -odir ..\..\..\Out\6502\Parts\WaltTrans
	