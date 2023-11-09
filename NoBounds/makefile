#define macros
DIR_EXTRAS = extras

DIR_SPARKLE = $(DIR_EXTRAS)\Sparkle
SPARKLE = $(DIR_SPARKLE)\Sparkle2.exe

DIR_KICKASS = $(DIR_EXTRAS)\KickAss
KICKASS = Java -jar $(DIR_KICKASS)\KickAss.jar

DIR_BASS = $(DIR_EXTRAS)\Bass
BASS = $(DIR_BASS)\Bass.exe

DIR_SPOT = $(DIR_EXTRAS)
SPOT = $(DIR_SPOT)\Spot.exe

DIR_DALI = $(DIR_EXTRAS)\Dali
DALI = $(DIR_DALI)\Dali.exe

DIR_ZIP = $(DIR_EXTRAS)\Zip
ZIP = $(DIR_ZIP)\zip.exe -j -X
STRIPZIP = $(DIR_ZIP)\stripzip.exe

DIR_C1541 = $(DIR_EXTRAS)\VICE\bin
C1541 = $(DIR_C1541)\c1541.exe

ASM_MAINDIR = Main
ASM_PARTSDIR = Parts
ASM_BUILDDIR = Build\6502
ASM_BUILDDIRREL = ..\Build\6502
ASM_BUILDDIRRELPARTS = ..\..\Build\6502
ASM_LINKDIR = Link
ASM_LINKDIRREL = ..\Link



#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# MAIN
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#FINAL ZIPFILE
D64\NoBounds.zip: D64\NoBounds-GP-Side1.d64 D64\NoBounds-GP-Side2.d64
	$(ZIP) D64\NoBounds.zip D64\NoBounds-GP-Side1.d64 D64\NoBounds-GP-Side2.d64
	$(STRIPZIP) D64\NoBounds.zip


#NoBoundsA.d64
D64\NoBounds-GP-Side1.d64: $(ASM_MAINDIR)\Sparkle\NoBounds.sls $(ASM_MAINDIR)\Sparkle\NoBoundsA.sls $(ASM_MAINDIR)\Sparkle\NoBoundsB.sls $(ASM_BUILDDIR)\Main\EntryWithBASICFade.prg $(ASM_BUILDDIR)\Main\EntryWithKefrens.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg D64\BigDXYCP.d64 D64\CheckerBoard.d64 D64\CheckerZoomer.d64 D64\ColourCycle.d64 D64\Earth.d64 D64\HiresLoader.d64 D64\InfiniteBobs.d64 D64\KefrensPlus.d64 D64\NoBounds.d64 D64\Parallax.d64 D64\PlasmaVector.d64 D64\PlotCube.d64 D64\RaytraceNightmare.d64 D64\ReflectorTW.d64 D64\RotatingGP.d64 D64\SpriteFPP.d64 D64\StarWars.d64 D64\TechTech.d64 D64\TinyCircleScroll.d64 D64\Trailblazer.d64 D64\TransitionScattered.d64 D64\TransitionSquares.d64 D64\Tunnel.d64 D64\TwistScroll.d64 D64\VerticalBitmapScroll.d64 Music\Psych858o-NoBounds.sid Music\Acrouzet-Golden.sid $(ASM_BUILDDIR)\StarWars\rastertrans.prg additional\notefile.prg
	$(SPARKLE) $(ASM_MAINDIR)\Sparkle\NoBounds.sls
    $(C1541) -attach D64\nobounds-gp-side1.d64 -write additional\notefile.prg "demo credits /gp"

#Main-BaseCode.prg
$(ASM_BUILDDIR)\Main\Main-BaseCode.prg: $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm
	$(KICKASS) $(ASM_MAINDIR)\Main-BaseCode.asm -odir $(ASM_BUILDDIRREL)\MAIN
	@if NOT EXIST "$(ASM_LINKDIR)\Main" mkdir "$(ASM_LINKDIR)\Main"
	copy $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_LINKDIR)\Main

#Entry.prg
$(ASM_BUILDDIR)\Main\Entry.prg: $(ASM_MAINDIR)\Entry.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm  $(ASM_BUILDDIR)\Main\Main-BaseCode.prg
	$(KICKASS) $(ASM_MAINDIR)\Entry.asm -odir $(ASM_BUILDDIRREL)\MAIN
	@if NOT EXIST "$(ASM_LINKDIR)\Main" mkdir "$(ASM_LINKDIR)\Main"
	copy $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_LINKDIR)\Main

#EntryWithBASICFade.prg
$(ASM_BUILDDIR)\Main\EntryWithBASICFade.prg: $(ASM_MAINDIR)\EntryWithBASICFade.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm  $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\BASICFade\BASICFade.prg $(ASM_BUILDDIR)\BASICFade\BASICFade2.prg
	$(KICKASS) $(ASM_MAINDIR)\EntryWithBASICFade.asm -odir $(ASM_BUILDDIRREL)\MAIN
	@if NOT EXIST "$(ASM_LINKDIR)\Main" mkdir "$(ASM_LINKDIR)\Main"
	copy $(ASM_BUILDDIR)\Main\EntryWithBASICFade.prg $(ASM_LINKDIR)\Main

#EntryWithKefrens.prg
$(ASM_BUILDDIR)\Main\EntryWithKefrens.prg: $(ASM_MAINDIR)\EntryWithKefrens.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm  $(ASM_BUILDDIR)\Main\Main-BaseCode.prg
	$(KICKASS) $(ASM_MAINDIR)\EntryWithKefrens.asm -odir $(ASM_BUILDDIRREL)\MAIN
	@if NOT EXIST "$(ASM_LINKDIR)\Main" mkdir "$(ASM_LINKDIR)\Main"
	copy $(ASM_BUILDDIR)\Main\EntryWithKefrens.prg $(ASM_LINKDIR)\Main

#DISK-EndOfDisk.prg
$(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg: $(ASM_MAINDIR)\DISK-EndOfDisk.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg
	$(KICKASS) $(ASM_MAINDIR)\DISK-EndOfDisk.asm -odir $(ASM_BUILDDIRREL)\MAIN
	@if NOT EXIST "$(ASM_LINKDIR)\Main" mkdir "$(ASM_LINKDIR)\Main"
	copy $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg $(ASM_LINKDIR)\Main

#BASICFade.prg
$(ASM_BUILDDIR)\BASICFade\BASICFade.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\BASICFade\BASICFade.asm $(ASM_PARTSDIR)\BASICFade\Data\SparkleLogoSprites.map
	$(KICKASS) $(ASM_PARTSDIR)\BASICFade\BASICFade.asm -odir $(ASM_BUILDDIRRELPARTS)\BASICFade
	@if NOT EXIST "$(ASM_LINKDIR)\BASICFade" mkdir "$(ASM_LINKDIR)\BASICFade"
	copy $(ASM_BUILDDIR)\BASICFade\BASICFade.prg $(ASM_LINKDIR)\BASICFade

#BASICFade2.prg
$(ASM_BUILDDIR)\BASICFade\BASICFade2.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\BASICFade\BASICFade2.asm
	$(KICKASS) $(ASM_PARTSDIR)\BASICFade\BASICFade2.asm -odir $(ASM_BUILDDIRRELPARTS)\BASICFade
	@if NOT EXIST "$(ASM_LINKDIR)\BASICFade" mkdir "$(ASM_LINKDIR)\BASICFade"
	copy $(ASM_BUILDDIR)\BASICFade\BASICFade2.prg $(ASM_LINKDIR)\BASICFade




#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DEMO PARTS BELOW ...
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#BigDXYCP --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\BigDXYCP.d64: $(ASM_PARTSDIR)\BigDXYCP\BigDXYCP.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\BigDXYCP\BigDXYCP.prg $(ASM_BUILDDIR)\BigDXYCP\BigDXYCP-DZX0.prg $(ASM_BUILDDIR)\BigDXYCP\DISK-BigDXYCP.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg $(ASM_PARTSDIR)\BigDXYCP\Data\startscreenchars.imap $(ASM_PARTSDIR)\BigDXYCP\Data\facet-302Bobs.map
	$(SPARKLE) $(ASM_PARTSDIR)\BigDXYCP\BigDXYCP.sls
	
$(ASM_BUILDDIR)\BigDXYCP\BigDXYCP.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\BigDXYCP\BigDXYCP.asm $(ASM_BUILDDIR)\BigDXYCP\Plot.asm $(ASM_LINKDIR)\BigDXYCP\Scrolltext.bin
	$(KICKASS) $(ASM_PARTSDIR)\BigDXYCP\BigDXYCP.asm -odir $(ASM_BUILDDIRRELPARTS)\BigDXYCP
	$(DALI) --from 0x2500 $(ASM_BUILDDIR)\BigDXYCP\BigDXYCP.prg
	@if NOT EXIST "$(ASM_LINKDIR)\BigDXYCP" mkdir "$(ASM_LINKDIR)\BigDXYCP"
	copy $(ASM_BUILDDIR)\BigDXYCP\BigDXYCP.prg $(ASM_LINKDIR)\BigDXYCP
	copy $(ASM_BUILDDIR)\BigDXYCP\BigDXYCP.prg.lz $(ASM_LINKDIR)\BigDXYCP

$(ASM_BUILDDIR)\BigDXYCP\BigDXYCP-DZX0.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\BigDXYCP\BigDXYCP-DZX0.asm
	$(KICKASS) $(ASM_PARTSDIR)\BigDXYCP\BigDXYCP-DZX0.asm -odir $(ASM_BUILDDIRRELPARTS)\BigDXYCP
	@if NOT EXIST "$(ASM_LINKDIR)\BigDXYCP" mkdir "$(ASM_LINKDIR)\BigDXYCP"
	copy $(ASM_BUILDDIR)\BigDXYCP\BigDXYCP-DZX0.prg $(ASM_LINKDIR)\BigDXYCP

$(ASM_BUILDDIR)\BigDXYCP\DISK-BigDXYCP.prg: $(ASM_PARTSDIR)\BigDXYCP\DISK-BigDXYCP.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\BigDXYCP\BigDXYCP.asm
	$(KICKASS) $(ASM_PARTSDIR)\BigDXYCP\DISK-BigDXYCP.asm -odir $(ASM_BUILDDIRRELPARTS)\BigDXYCP
	@if NOT EXIST "$(ASM_LINKDIR)\BigDXYCP" mkdir "$(ASM_LINKDIR)\BigDXYCP"
	copy $(ASM_BUILDDIR)\BigDXYCP\DISK-BigDXYCP.prg $(ASM_LINKDIR)\BigDXYCP
	


#CheckerBoard --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\CheckerBoard.d64: $(ASM_PARTSDIR)\CheckerBoard\CheckerBoard.sls $(ASM_BUILDDIR)\CheckerBoard\CheckerBoard.prg $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\CheckerBoard\DISK-CheckerBoard.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg $(ASM_LINKDIR)\CheckerBoard\ShiftedData.bin $(ASM_PARTSDIR)\CheckerBoard\Data\RandomC2.bin $(ASM_PARTSDIR)\CheckerBoard\Data\LogoSpritesGenesis.map $(ASM_PARTSDIR)\CheckerBoard\Data\LogoSpritesProject.map $(ASM_PARTSDIR)\CheckerBoard\Data\LogoSpritesNobounds.map
	$(SPARKLE) $(ASM_PARTSDIR)\CheckerBoard\CheckerBoard.sls

$(ASM_BUILDDIR)\CheckerBoard\CheckerBoard.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\CheckerBoard\CheckerBoard.asm
	$(KICKASS) $(ASM_PARTSDIR)\CheckerBoard\CheckerBoard.asm -odir $(ASM_BUILDDIRRELPARTS)\CheckerBoard
	@if NOT EXIST "$(ASM_LINKDIR)\CheckerBoard" mkdir "$(ASM_LINKDIR)\CheckerBoard"
	copy $(ASM_BUILDDIR)\CheckerBoard\CheckerBoard.prg $(ASM_LINKDIR)\CheckerBoard

$(ASM_BUILDDIR)\CheckerBoard\DISK-CheckerBoard.prg: $(ASM_PARTSDIR)\CheckerBoard\DISK-CheckerBoard.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\CheckerBoard\CheckerBoard.prg
	$(KICKASS) $(ASM_PARTSDIR)\CheckerBoard\DISK-CheckerBoard.asm -odir $(ASM_BUILDDIRRELPARTS)\CheckerBoard
	@if NOT EXIST "$(ASM_LINKDIR)\CheckerBoard" mkdir "$(ASM_LINKDIR)\CheckerBoard"
	copy $(ASM_BUILDDIR)\CheckerBoard\DISK-CheckerBoard.prg $(ASM_LINKDIR)\CheckerBoard
	


#CheckerZoomer --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\CheckerZoomer.d64: $(ASM_PARTSDIR)\CheckerZoomer\CheckerZoomer.sls $(ASM_BUILDDIR)\CheckerZoomer\CheckerZoomer.prg $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\CheckerZoomer\DISK-CheckerZoomer.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg $(ASM_LINKDIR)\CheckerZoomer\SpriteData.bin $(ASM_LINKDIR)\CheckerZoomer\PointerData.bin $(ASM_LINKDIR)\CheckerZoomer\ZoomPhases.bin $(ASM_LINKDIR)\CheckerZoomer\Chessboard.map $(ASM_PARTSDIR)\CheckerZoomer\Data\ChessPiecesMC.bin
	$(SPARKLE) $(ASM_PARTSDIR)\CheckerZoomer\CheckerZoomer.sls

$(ASM_LINKDIR)\CheckerZoomer\Chessboard.map:  $(ASM_PARTSDIR)\CheckerZoomer\Data\Chessboard.png
	$(SPOT) $(ASM_PARTSDIR)\CheckerZoomer\Data\Chessboard.png msc $(ASM_LINKDIR)\CheckerZoomer\Chessboard 0

$(ASM_BUILDDIR)\CheckerZoomer\CheckerZoomer.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\CheckerZoomer\CheckerZoomer.asm
	$(KICKASS) $(ASM_PARTSDIR)\CheckerZoomer\CheckerZoomer.asm -odir $(ASM_BUILDDIRRELPARTS)\CheckerZoomer
	@if NOT EXIST "$(ASM_LINKDIR)\CheckerZoomer" mkdir "$(ASM_LINKDIR)\CheckerZoomer"
	copy $(ASM_BUILDDIR)\CheckerZoomer\CheckerZoomer.prg $(ASM_LINKDIR)\CheckerZoomer

$(ASM_BUILDDIR)\CheckerZoomer\DISK-CheckerZoomer.prg: $(ASM_PARTSDIR)\CheckerZoomer\DISK-CheckerZoomer.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\CheckerZoomer\CheckerZoomer.prg
	$(KICKASS) $(ASM_PARTSDIR)\CheckerZoomer\DISK-CheckerZoomer.asm -odir $(ASM_BUILDDIRRELPARTS)\CheckerZoomer
	@if NOT EXIST "$(ASM_LINKDIR)\CheckerZoomer" mkdir "$(ASM_LINKDIR)\CheckerZoomer"
	copy $(ASM_BUILDDIR)\CheckerZoomer\DISK-CheckerZoomer.prg $(ASM_LINKDIR)\CheckerZoomer



#ColourCycle --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\ColourCycle.d64: $(ASM_PARTSDIR)\ColourCycle\ColourCycle.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\ColourCycle\ColourCycle.prg $(ASM_BUILDDIR)\ColourCycle\Tardis.prg $(ASM_BUILDDIR)\ColourCycle\CC0.prg $(ASM_BUILDDIR)\ColourCycle\CC0A.prg $(ASM_BUILDDIR)\ColourCycle\CC0B.prg $(ASM_BUILDDIR)\ColourCycle\CC1.prg $(ASM_BUILDDIR)\ColourCycle\CC1A.prg $(ASM_BUILDDIR)\ColourCycle\CC1B.prg $(ASM_BUILDDIR)\ColourCycle\CC2.prg $(ASM_BUILDDIR)\ColourCycle\CC2A.prg $(ASM_BUILDDIR)\ColourCycle\CC2B.prg $(ASM_BUILDDIR)\ColourCycle\DISK-ColourCycle.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\ColourCycle\ColourCycle.sls

$(ASM_BUILDDIR)\ColourCycle\ColourCycle.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\ColourCycle\ColourCycle.asm $(ASM_BUILDDIR)\ColourCycle\CC0.asm $(ASM_BUILDDIR)\ColourCycle\CC0A.asm $(ASM_BUILDDIR)\ColourCycle\CC0B.asm $(ASM_BUILDDIR)\ColourCycle\CC1.asm $(ASM_BUILDDIR)\ColourCycle\CC1A.asm $(ASM_BUILDDIR)\ColourCycle\CC1B.asm $(ASM_BUILDDIR)\ColourCycle\CC2.asm $(ASM_BUILDDIR)\ColourCycle\CC2A.asm $(ASM_BUILDDIR)\ColourCycle\CC2B.asm $(ASM_PARTSDIR)\ColourCycle\Tardis.asm
	$(KICKASS) $(ASM_PARTSDIR)\ColourCycle\ColourCycle.asm -odir $(ASM_BUILDDIRRELPARTS)\ColourCycle
	$(KICKASS) $(ASM_PARTSDIR)\ColourCycle\Tardis.asm -odir $(ASM_BUILDDIRRELPARTS)\ColourCycle
	$(KICKASS) $(ASM_BUILDDIR)\ColourCycle\CC0.asm
	$(KICKASS) $(ASM_BUILDDIR)\ColourCycle\CC0A.asm
	$(KICKASS) $(ASM_BUILDDIR)\ColourCycle\CC0B.asm
	$(KICKASS) $(ASM_BUILDDIR)\ColourCycle\CC1.asm
	$(KICKASS) $(ASM_BUILDDIR)\ColourCycle\CC1A.asm
	$(KICKASS) $(ASM_BUILDDIR)\ColourCycle\CC1B.asm
	$(KICKASS) $(ASM_BUILDDIR)\ColourCycle\CC2.asm
	$(KICKASS) $(ASM_BUILDDIR)\ColourCycle\CC2A.asm
	$(KICKASS) $(ASM_BUILDDIR)\ColourCycle\CC2B.asm
	@if NOT EXIST "$(ASM_LINKDIR)\ColourCycle" mkdir "$(ASM_LINKDIR)\ColourCycle"
	copy $(ASM_BUILDDIR)\ColourCycle\Tardis.prg $(ASM_LINKDIR)\ColourCycle
	copy $(ASM_BUILDDIR)\ColourCycle\CC0.prg $(ASM_LINKDIR)\ColourCycle
	copy $(ASM_BUILDDIR)\ColourCycle\CC0A.prg $(ASM_LINKDIR)\ColourCycle
	copy $(ASM_BUILDDIR)\ColourCycle\CC0B.prg $(ASM_LINKDIR)\ColourCycle
	copy $(ASM_BUILDDIR)\ColourCycle\CC1.prg $(ASM_LINKDIR)\ColourCycle
	copy $(ASM_BUILDDIR)\ColourCycle\CC1A.prg $(ASM_LINKDIR)\ColourCycle
	copy $(ASM_BUILDDIR)\ColourCycle\CC1B.prg $(ASM_LINKDIR)\ColourCycle
	copy $(ASM_BUILDDIR)\ColourCycle\CC2.prg $(ASM_LINKDIR)\ColourCycle
	copy $(ASM_BUILDDIR)\ColourCycle\CC2A.prg $(ASM_LINKDIR)\ColourCycle
	copy $(ASM_BUILDDIR)\ColourCycle\CC2B.prg $(ASM_LINKDIR)\ColourCycle
	copy $(ASM_BUILDDIR)\ColourCycle\ColourCycle.prg $(ASM_LINKDIR)\ColourCycle

$(ASM_BUILDDIR)\ColourCycle\DISK-ColourCycle.prg: $(ASM_PARTSDIR)\ColourCycle\DISK-ColourCycle.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\ColourCycle\ColourCycle.asm
	$(KICKASS) $(ASM_PARTSDIR)\ColourCycle\DISK-ColourCycle.asm -odir $(ASM_BUILDDIRRELPARTS)\ColourCycle
	@if NOT EXIST "$(ASM_LINKDIR)\ColourCycle" mkdir "$(ASM_LINKDIR)\ColourCycle"
	copy $(ASM_BUILDDIR)\ColourCycle\DISK-ColourCycle.prg $(ASM_LINKDIR)\ColourCycle



#Earth --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\Earth.d64: $(ASM_PARTSDIR)\Earth\Earth.sls $(ASM_BUILDDIR)\Earth\Earth.prg $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\Earth\DISK-Earth.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg $(ASM_LINKDIR)\Earth\Map.bin $(ASM_LINKDIR)\Earth\Offsets.bin $(ASM_LINKDIR)\Earth\ByteCnt.bin $(ASM_LINKDIR)\Earth\SpriteInterleave.bin $(ASM_LINKDIR)\Earth\BlueglobeSprites.bin $(ASM_LINKDIR)\Earth\SineTable.bin $(ASM_LINKDIR)\Earth\FacetSun.map
	$(SPARKLE) $(ASM_PARTSDIR)\Earth\Earth.sls

$(ASM_LINKDIR)\Earth\Facetsun.map: $(ASM_PARTSDIR)\Earth\Data\FacetSun.png
	@if NOT EXIST "$(ASM_LINKDIR)\Earth" mkdir "$(ASM_LINKDIR)\Earth"
	$(SPOT) $(ASM_PARTSDIR)\Earth\Data\FacetSun.png msc $(ASM_LINKDIR)\Earth\FacetSun

$(ASM_BUILDDIR)\Earth\Earth.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\Earth\Earth.asm
	$(KICKASS) $(ASM_PARTSDIR)\Earth\Earth.asm -odir $(ASM_BUILDDIRRELPARTS)\Earth
	@if NOT EXIST "$(ASM_LINKDIR)\Earth" mkdir "$(ASM_LINKDIR)\Earth"
	copy $(ASM_BUILDDIR)\Earth\Earth.prg $(ASM_LINKDIR)\Earth

$(ASM_BUILDDIR)\Earth\DISK-Earth.prg: $(ASM_PARTSDIR)\Earth\DISK-Earth.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\Earth\Earth.prg
	$(KICKASS) $(ASM_PARTSDIR)\Earth\DISK-Earth.asm -odir $(ASM_BUILDDIRRELPARTS)\Earth
	@if NOT EXIST "$(ASM_LINKDIR)\Earth" mkdir "$(ASM_LINKDIR)\Earth"
	copy $(ASM_BUILDDIR)\Earth\DISK-Earth.prg $(ASM_LINKDIR)\Earth



#HiresLoader --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\HiresLoader.d64: $(ASM_PARTSDIR)\HiresLoader\HiresLoader.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\HiresLoader\HiresLoader.prg $(ASM_BUILDDIR)\HiresLoader\DISK-HiresLoader.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\HiresLoader\HiresLoader.sls

$(ASM_BUILDDIR)\HiresLoader\HiresLoader.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\HiresLoader\HiresLoader.asm $(ASM_PARTSDIR)\HiresLoader\functions.asm $(ASM_PARTSDIR)\HiresLoader\scene_settings.asm $(ASM_PARTSDIR)\HiresLoader\variables.asm
	$(KICKASS) $(ASM_PARTSDIR)\HiresLoader\HiresLoader.asm -odir $(ASM_BUILDDIRRELPARTS)\HiresLoader
	@if NOT EXIST "$(ASM_LINKDIR)\HiresLoader" mkdir "$(ASM_LINKDIR)\HiresLoader"
	copy $(ASM_BUILDDIR)\HiresLoader\HiresLoader.prg $(ASM_LINKDIR)\HiresLoader

$(ASM_BUILDDIR)\HiresLoader\DISK-HiresLoader.prg: $(ASM_PARTSDIR)\HiresLoader\DISK-HiresLoader.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\HiresLoader\HiresLoader.asm
	$(KICKASS) $(ASM_PARTSDIR)\HiresLoader\DISK-HiresLoader.asm -odir $(ASM_BUILDDIRRELPARTS)\HiresLoader
	@if NOT EXIST "$(ASM_LINKDIR)\HiresLoader" mkdir "$(ASM_LINKDIR)\HiresLoader"
	copy $(ASM_BUILDDIR)\HiresLoader\DISK-HiresLoader.prg $(ASM_LINKDIR)\HiresLoader



#InfiniteBobs --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\InfiniteBobs.d64: $(ASM_PARTSDIR)\InfiniteBobs\InfiniteBobs.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\InfiniteBobs\InfiniteBobs.prg $(ASM_BUILDDIR)\InfiniteBobs\InfiniteBobs-FinalRasterFade.prg $(ASM_BUILDDIR)\InfiniteBobs\DISK-InfiniteBobs.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\InfiniteBobs\InfiniteBobs.sls

$(ASM_BUILDDIR)\InfiniteBobs\InfiniteBobs.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\InfiniteBobs\InfiniteBobs.asm $(ASM_BUILDDIR)\InfiniteBobs\Bob.asm
	$(KICKASS) $(ASM_PARTSDIR)\InfiniteBobs\InfiniteBobs.asm -odir $(ASM_BUILDDIRRELPARTS)\InfiniteBobs
	@if NOT EXIST "$(ASM_LINKDIR)\InfiniteBobs" mkdir "$(ASM_LINKDIR)\InfiniteBobs"
	copy $(ASM_BUILDDIR)\InfiniteBobs\InfiniteBobs.prg $(ASM_LINKDIR)\InfiniteBobs

$(ASM_BUILDDIR)\InfiniteBobs\InfiniteBobs-FinalRasterFade.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\InfiniteBobs\InfiniteBobs-FinalRasterFade.asm
	$(KICKASS) $(ASM_PARTSDIR)\InfiniteBobs\\InfiniteBobs-FinalRasterFade.asm -odir $(ASM_BUILDDIRRELPARTS)\InfiniteBobs
	@if NOT EXIST "$(ASM_LINKDIR)\InfiniteBobs" mkdir "$(ASM_LINKDIR)\InfiniteBobs"
	copy $(ASM_BUILDDIR)\InfiniteBobs\\InfiniteBobs-FinalRasterFade.prg $(ASM_LINKDIR)\InfiniteBobs

$(ASM_BUILDDIR)\InfiniteBobs\DISK-InfiniteBobs.prg: $(ASM_PARTSDIR)\InfiniteBobs\DISK-InfiniteBobs.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\InfiniteBobs\InfiniteBobs.asm
	$(KICKASS) $(ASM_PARTSDIR)\InfiniteBobs\DISK-InfiniteBobs.asm -odir $(ASM_BUILDDIRRELPARTS)\InfiniteBobs
	@if NOT EXIST "$(ASM_LINKDIR)\InfiniteBobs" mkdir "$(ASM_LINKDIR)\InfiniteBobs"
	copy $(ASM_BUILDDIR)\InfiniteBobs\DISK-InfiniteBobs.prg $(ASM_LINKDIR)\InfiniteBobs



#KefrensPlus --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\KefrensPlus.d64: $(ASM_PARTSDIR)\KefrensPlus\KefrensPlus.sls $(ASM_BUILDDIR)\KefrensPlus\KefrensPlus.prg $(ASM_BUILDDIR)\KefrensPlus\KefrensPlusFadeIn.prg $(ASM_PARTSDIR)\KefrensPlus\Data\RaisingTheBarsChars.bin $(ASM_PARTSDIR)\KefrensPlus\Data\RaisingTheBarsScreen.bin $(ASM_PARTSDIR)\KefrensPlus\Data\BordersForBooze.map $(ASM_PARTSDIR)\KefrensPlus\Data\NoBoundsForGP.map $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\KefrensPlus\DISK-KefrensPlus.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg Music\Acrouzet-Golden-F000.sid
	$(SPARKLE) $(ASM_PARTSDIR)\KefrensPlus\KefrensPlus.sls
	
$(ASM_BUILDDIR)\KefrensPlus\KefrensPlus.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\KefrensPlus\KefrensPlus.asm
	$(KICKASS) $(ASM_PARTSDIR)\KefrensPlus\KefrensPlus.asm -odir "$(ASM_BUILDDIRRELPARTS)\KefrensPlus"
	@if NOT EXIST "$(ASM_LINKDIR)\KefrensPlus" mkdir "$(ASM_LINKDIR)\KefrensPlus"
	copy $(ASM_BUILDDIR)\KefrensPlus\KefrensPlus.prg "$(ASM_LINKDIR)\KefrensPlus"

$(ASM_BUILDDIR)\KefrensPlus\KefrensPlusFadeIn.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\KefrensPlus\KefrensPlusFadeIn.asm $(ASM_PARTSDIR)\KefrensPlus\KefrensPlus.asm
	$(KICKASS) $(ASM_PARTSDIR)\KefrensPlus\KefrensPlusFadeIn.asm -odir "$(ASM_BUILDDIRRELPARTS)\KefrensPlus"
	@if NOT EXIST "$(ASM_LINKDIR)\KefrensPlus" mkdir "$(ASM_LINKDIR)\KefrensPlus"
	copy $(ASM_BUILDDIR)\KefrensPlus\KefrensPlusFadeIn.prg "$(ASM_LINKDIR)\KefrensPlus"

$(ASM_BUILDDIR)\KefrensPlus\DISK-KefrensPlus.prg: $(ASM_PARTSDIR)\KefrensPlus\DISK-KefrensPlus.asm $(ASM_PARTSDIR)\KefrensPlus\KefrensPlus.asm $(ASM_PARTSDIR)\KefrensPlus\KefrensPlusFadeIn.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\KefrensPlus\KefrensPlusFadeIn.prg
	$(KICKASS) $(ASM_PARTSDIR)\KefrensPlus\DISK-KefrensPlus.asm -odir "$(ASM_BUILDDIRRELPARTS)\KefrensPlus"
	@if NOT EXIST "$(ASM_LINKDIR)\KefrensPlus" mkdir "$(ASM_LINKDIR)\KefrensPlus"
	copy $(ASM_BUILDDIR)\KefrensPlus\DISK-KefrensPlus.prg "$(ASM_LINKDIR)\KefrensPlus"



#NoBounds --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\NoBounds.d64: $(ASM_PARTSDIR)\NoBounds\NoBounds.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\NoBounds\NoBounds.prg $(ASM_BUILDDIR)\NoBounds\FadeFromNoBounds_RasterUpdateData.prg $(ASM_BUILDDIR)\NoBounds\FadeFromNoBounds.prg $(ASM_BUILDDIR)\NoBounds\DISK-NoBounds.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\NoBounds\NoBounds.sls

$(ASM_BUILDDIR)\NoBounds\NoBounds.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\NoBounds\NoBounds.asm $(ASM_BUILDDIR)\NoBounds\RasterCode.asm
	$(KICKASS) $(ASM_PARTSDIR)\NoBounds\NoBounds.asm -odir $(ASM_BUILDDIRRELPARTS)\NoBounds
	@if NOT EXIST "$(ASM_LINKDIR)\NoBounds" mkdir "$(ASM_LINKDIR)\NoBounds"
	copy $(ASM_BUILDDIR)\NoBounds\NoBounds.prg $(ASM_LINKDIR)\NoBounds

$(ASM_BUILDDIR)\NoBounds\FadeFromNoBounds_RasterUpdateData.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_BUILDDIR)\NoBounds\FadeFromNoBounds_RasterUpdateData.asm
	$(KICKASS) $(ASM_BUILDDIR)\NoBounds\FadeFromNoBounds_RasterUpdateData.asm
	@if NOT EXIST "$(ASM_LINKDIR)\NoBounds" mkdir "$(ASM_LINKDIR)\NoBounds"
	copy $(ASM_BUILDDIR)\NoBounds\FadeFromNoBounds_RasterUpdateData.prg $(ASM_LINKDIR)\NoBounds

$(ASM_BUILDDIR)\NoBounds\FadeFromNoBounds.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\NoBounds\FadeFromNoBounds.asm
	$(KICKASS) $(ASM_PARTSDIR)\NoBounds\FadeFromNoBounds.asm -odir $(ASM_BUILDDIRRELPARTS)\NoBounds
	@if NOT EXIST "$(ASM_LINKDIR)\NoBounds" mkdir "$(ASM_LINKDIR)\NoBounds"
	copy $(ASM_BUILDDIR)\NoBounds\FadeFromNoBounds.prg $(ASM_LINKDIR)\NoBounds

$(ASM_BUILDDIR)\NoBounds\DISK-NoBounds.prg: $(ASM_PARTSDIR)\NoBounds\DISK-NoBounds.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\NoBounds\NoBounds.asm
	$(KICKASS) $(ASM_PARTSDIR)\NoBounds\DISK-NoBounds.asm -odir $(ASM_BUILDDIRRELPARTS)\NoBounds
	@if NOT EXIST "$(ASM_LINKDIR)\NoBounds" mkdir "$(ASM_LINKDIR)\NoBounds"
	copy $(ASM_BUILDDIR)\NoBounds\DISK-NoBounds.prg $(ASM_LINKDIR)\NoBounds



#Parallax --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\Parallax.d64: $(ASM_PARTSDIR)\Parallax\Parallax.sls $(ASM_BUILDDIR)\Parallax\Parallax.prg $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\Parallax\DISK-Parallax.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\Parallax\Parallax.sls
	
$(ASM_BUILDDIR)\Parallax\Parallax.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\Parallax\Parallax.asm
	$(KICKASS) $(ASM_PARTSDIR)\Parallax\Parallax.asm -odir $(ASM_BUILDDIRRELPARTS)\Parallax
	@if NOT EXIST "$(ASM_LINKDIR)\Parallax" mkdir "$(ASM_LINKDIR)\Parallax"
	copy $(ASM_BUILDDIR)\Parallax\Parallax.prg $(ASM_LINKDIR)\Parallax

$(ASM_BUILDDIR)\Parallax\DISK-Parallax.prg: $(ASM_PARTSDIR)\Parallax\DISK-Parallax.asm $(ASM_PARTSDIR)\Parallax\Parallax.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg
	$(KICKASS) $(ASM_PARTSDIR)\Parallax\DISK-Parallax.asm -odir $(ASM_BUILDDIRRELPARTS)\Parallax
	@if NOT EXIST "$(ASM_LINKDIR)\Parallax" mkdir "$(ASM_LINKDIR)\Parallax"
	copy $(ASM_BUILDDIR)\Parallax\DISK-Parallax.prg $(ASM_LINKDIR)\Parallax



#PlasmaVector --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\PlasmaVector.d64: $(ASM_PARTSDIR)\PlasmaVector\PlasmaVector.sls $(ASM_BUILDDIR)\PlasmaVector\PlasmaVector.prg $(ASM_BUILDDIR)\PlasmaVector\PlasmaVectorIntro.prg $(ASM_PARTSDIR)\PlasmaVector\Data\CoverSprites.bin $(ASM_PARTSDIR)\PlasmaVector\Data\Cube.bin $(ASM_PARTSDIR)\PlasmaVector\Data\FaceVis.bin $(ASM_PARTSDIR)\PlasmaVector\Data\Pattern80-BF.bin $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\PlasmaVector\DISK-PlasmaVector.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg $(ASM_LINKDIR)\PlasmaVector\RazorbackUnbound.map
	$(SPARKLE) $(ASM_PARTSDIR)\PlasmaVector\PlasmaVector.sls
	
$(ASM_LINKDIR)\PlasmaVector\RazorbackUnbound.map:  $(ASM_PARTSDIR)\PlasmaVector\Data\RazorbackUnbound.png
	@if NOT EXIST "$(ASM_LINKDIR)\PlasmaVector" mkdir "$(ASM_LINKDIR)\PlasmaVector"
	$(SPOT) $(ASM_PARTSDIR)\PlasmaVector\Data\RazorbackUnbound.png msc $(ASM_LINKDIR)\PlasmaVector\RazorbackUnbound 0
	
$(ASM_BUILDDIR)\PlasmaVector\PlasmaVectorIntro.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\PlasmaVector\PlasmaVectorIntro.asm
	$(KICKASS) $(ASM_PARTSDIR)\PlasmaVector\PlasmaVectorIntro.asm -odir $(ASM_BUILDDIRRELPARTS)\PlasmaVector
	@if NOT EXIST "$(ASM_LINKDIR)\PlasmaVector" mkdir "$(ASM_LINKDIR)\PlasmaVector"
	copy $(ASM_BUILDDIR)\PlasmaVector\PlasmaVectorIntro.prg $(ASM_LINKDIR)\PlasmaVector
	
$(ASM_BUILDDIR)\PlasmaVector\PlasmaVector.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\PlasmaVector\PlasmaVector.asm
	$(KICKASS) $(ASM_PARTSDIR)\PlasmaVector\PlasmaVector.asm -odir $(ASM_BUILDDIRRELPARTS)\PlasmaVector :test=false
	@if NOT EXIST "$(ASM_LINKDIR)\PlasmaVector" mkdir "$(ASM_LINKDIR)\PlasmaVector"
	copy $(ASM_BUILDDIR)\PlasmaVector\PlasmaVector.prg $(ASM_LINKDIR)\PlasmaVector

$(ASM_BUILDDIR)\PlasmaVector\DISK-PlasmaVector.prg: $(ASM_PARTSDIR)\PlasmaVector\DISK-PlasmaVector.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\PlasmaVector\PlasmaVector.prg
	$(KICKASS) $(ASM_PARTSDIR)\PlasmaVector\DISK-PlasmaVector.asm -odir $(ASM_BUILDDIRRELPARTS)\PlasmaVector
	@if NOT EXIST "$(ASM_LINKDIR)\PlasmaVector" mkdir "$(ASM_LINKDIR)\PlasmaVector"
	copy $(ASM_BUILDDIR)\PlasmaVector\DISK-PlasmaVector.prg $(ASM_LINKDIR)\PlasmaVector



#PlotCube --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\PlotCube.d64: $(ASM_PARTSDIR)\PlotCube\PlotCube.sls $(ASM_BUILDDIR)\PlotCube\PlotCubeIntro.prg $(ASM_BUILDDIR)\PlotCube\PlotCube.prg $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\PlotCube\DISK-PlotCube.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg $(ASM_LINKDIR)\PlotCube\RedcrabPodium00.map $(ASM_LINKDIR)\PlotCube\RedcrabPodium0.map $(ASM_LINKDIR)\PlotCube\RedcrabPodium1.map $(ASM_LINKDIR)\PlotCube\RedcrabPodium2.map $(ASM_LINKDIR)\PlotCube\RedcrabPodium3.map
	$(SPARKLE) $(ASM_PARTSDIR)\PlotCube\PlotCube.sls
	
$(ASM_LINKDIR)\PlotCube\RedcrabPodium00.map:  $(ASM_PARTSDIR)\PlotCube\Data\RedcrabPodium00.png
	@if NOT EXIST "$(ASM_LINKDIR)\Plotcube" mkdir "$(ASM_LINKDIR)\PlotCube"
	$(SPOT) $(ASM_PARTSDIR)\PlotCube\Data\RedcrabPodium00.png msc $(ASM_LINKDIR)\PlotCube\RedcrabPodium00 8
	
$(ASM_LINKDIR)\PlotCube\RedcrabPodium0.map:  $(ASM_PARTSDIR)\PlotCube\Data\RedcrabPodium0.png
	@if NOT EXIST "$(ASM_LINKDIR)\Plotcube" mkdir "$(ASM_LINKDIR)\PlotCube"
	$(SPOT) $(ASM_PARTSDIR)\PlotCube\Data\RedcrabPodium0.png msc $(ASM_LINKDIR)\PlotCube\RedcrabPodium0 8
	
$(ASM_LINKDIR)\PlotCube\RedcrabPodium1.map:  $(ASM_PARTSDIR)\PlotCube\Data\RedcrabPodium1.png
	@if NOT EXIST "$(ASM_LINKDIR)\Plotcube" mkdir "$(ASM_LINKDIR)\PlotCube"
	$(SPOT) $(ASM_PARTSDIR)\PlotCube\Data\RedcrabPodium1.png msc $(ASM_LINKDIR)\PlotCube\RedcrabPodium1 8
	
$(ASM_LINKDIR)\PlotCube\RedcrabPodium2.map:  $(ASM_PARTSDIR)\PlotCube\Data\RedcrabPodium2.png
	@if NOT EXIST "$(ASM_LINKDIR)\Plotcube" mkdir "$(ASM_LINKDIR)\PlotCube"
	$(SPOT) $(ASM_PARTSDIR)\PlotCube\Data\RedcrabPodium2.png msc $(ASM_LINKDIR)\PlotCube\RedcrabPodium2 8
	
$(ASM_LINKDIR)\PlotCube\RedcrabPodium3.map:  $(ASM_PARTSDIR)\PlotCube\Data\RedcrabPodium3.png
	@if NOT EXIST "$(ASM_LINKDIR)\Plotcube" mkdir "$(ASM_LINKDIR)\PlotCube"
	$(SPOT) $(ASM_PARTSDIR)\PlotCube\Data\RedcrabPodium3.png msc $(ASM_LINKDIR)\PlotCube\RedcrabPodium3 8

$(ASM_BUILDDIR)\PlotCube\PlotCubeIntro.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\PlotCube\PlotCubeIntro.asm
	$(KICKASS) $(ASM_PARTSDIR)\PlotCube\PlotCubeIntro.asm -odir $(ASM_BUILDDIRRELPARTS)\PlotCube :test=false
	@if NOT EXIST "$(ASM_LINKDIR)\PlotCube" mkdir "$(ASM_LINKDIR)\PlotCube"
	copy $(ASM_BUILDDIR)\PlotCube\PlotCubeIntro.prg $(ASM_LINKDIR)\PlotCube

$(ASM_BUILDDIR)\PlotCube\PlotCube.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\PlotCube\PlotCube.asm
	$(KICKASS) $(ASM_PARTSDIR)\PlotCube\PlotCube.asm -odir $(ASM_BUILDDIRRELPARTS)\PlotCube :test=false
	@if NOT EXIST "$(ASM_LINKDIR)\PlotCube" mkdir "$(ASM_LINKDIR)\PlotCube"
	copy $(ASM_BUILDDIR)\PlotCube\PlotCube.prg $(ASM_LINKDIR)\PlotCube

$(ASM_BUILDDIR)\PlotCube\DISK-PlotCube.prg: $(ASM_PARTSDIR)\PlotCube\DISK-PlotCube.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\PlotCube\PlotCube.prg
	$(KICKASS) $(ASM_PARTSDIR)\PlotCube\DISK-PlotCube.asm -odir $(ASM_BUILDDIRRELPARTS)\PlotCube
	@if NOT EXIST "$(ASM_LINKDIR)\PlotCube" mkdir "$(ASM_LINKDIR)\PlotCube"
	copy $(ASM_BUILDDIR)\PlotCube\DISK-PlotCube.prg $(ASM_LINKDIR)\PlotCube



#RaytraceNightmare --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\RaytraceNightmare.d64: $(ASM_PARTSDIR)\RaytraceNightmare\RaytraceNightmare.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\RaytraceNightmare\RaytraceNightmare.prg $(ASM_BUILDDIR)\RaytraceNightmare\DISK-RaytraceNightmare.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\RaytraceNightmare\RaytraceNightmare.sls

$(ASM_BUILDDIR)\RaytraceNightmare\RaytraceNightmare.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\RaytraceNightmare\RaytraceNightmare.asm $(ASM_PARTSDIR)\RaytraceNightmare\functions.asm $(ASM_PARTSDIR)\RaytraceNightmare\vsp.asm $(ASM_PARTSDIR)\RaytraceNightmare\unrolled_irq.asm $(ASM_PARTSDIR)\RaytraceNightmare\scene_settings.asm $(ASM_PARTSDIR)\RaytraceNightmare\variables.asm
	$(KICKASS) $(ASM_PARTSDIR)\RaytraceNightmare\RaytraceNightmare.asm -odir $(ASM_BUILDDIRRELPARTS)\RaytraceNightmare
	@if NOT EXIST "$(ASM_LINKDIR)\RaytraceNightmare" mkdir "$(ASM_LINKDIR)\RaytraceNightmare"
	copy $(ASM_BUILDDIR)\RaytraceNightmare\RaytraceNightmare.prg $(ASM_LINKDIR)\RaytraceNightmare

$(ASM_BUILDDIR)\RaytraceNightmare\DISK-RaytraceNightmare.prg: $(ASM_PARTSDIR)\RaytraceNightmare\DISK-RaytraceNightmare.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\RaytraceNightmare\RaytraceNightmare.asm
	$(KICKASS) $(ASM_PARTSDIR)\RaytraceNightmare\DISK-RaytraceNightmare.asm -odir $(ASM_BUILDDIRRELPARTS)\RaytraceNightmare
	@if NOT EXIST "$(ASM_LINKDIR)\RaytraceNightmare" mkdir "$(ASM_LINKDIR)\RaytraceNightmare"
	copy $(ASM_BUILDDIR)\RaytraceNightmare\DISK-RaytraceNightmare.prg $(ASM_LINKDIR)\RaytraceNightmare



#ReflectorTW --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\ReflectorTW.d64: $(ASM_PARTSDIR)\ReflectorTW\ReflectorTW.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\ReflectorTW\ReflectorTW.prg $(ASM_BUILDDIR)\ReflectorTW\ReflectorTransition.prg $(ASM_BUILDDIR)\ReflectorTW\DISK-ReflectorTW.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\ReflectorTW\ReflectorTW.sls

$(ASM_BUILDDIR)\ReflectorTW\ReflectorTW.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\ReflectorTW\ReflectorTW.asm $(ASM_PARTSDIR)\ReflectorTW\functions.asm  $(ASM_PARTSDIR)\ReflectorTW\ReflectorTransition.asm  $(ASM_PARTSDIR)\ReflectorTW\transition_functions.asm $(ASM_PARTSDIR)\ReflectorTW\transition_intro.asm $(ASM_PARTSDIR)\ReflectorTW\scene_settings.asm $(ASM_PARTSDIR)\ReflectorTW\variables.asm $(ASM_PARTSDIR)\ReflectorTW\intro.asm
	$(KICKASS) $(ASM_PARTSDIR)\ReflectorTW\ReflectorTW.asm -odir $(ASM_BUILDDIRRELPARTS)\ReflectorTW
	@if NOT EXIST "$(ASM_LINKDIR)\ReflectorTW" mkdir "$(ASM_LINKDIR)\ReflectorTW"
	copy $(ASM_BUILDDIR)\ReflectorTW\ReflectorTW.prg $(ASM_LINKDIR)\ReflectorTW

$(ASM_BUILDDIR)\ReflectorTW\ReflectorTransition.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\ReflectorTW\ReflectorTW.asm $(ASM_PARTSDIR)\ReflectorTW\functions.asm  $(ASM_PARTSDIR)\ReflectorTW\ReflectorTransition.asm  $(ASM_PARTSDIR)\ReflectorTW\transition_functions.asm $(ASM_PARTSDIR)\ReflectorTW\transition_intro.asm $(ASM_PARTSDIR)\ReflectorTW\scene_settings.asm $(ASM_PARTSDIR)\ReflectorTW\variables.asm
	$(KICKASS) $(ASM_PARTSDIR)\ReflectorTW\ReflectorTransition.asm -odir $(ASM_BUILDDIRRELPARTS)\ReflectorTW
	@if NOT EXIST "$(ASM_LINKDIR)\ReflectorTW" mkdir "$(ASM_LINKDIR)\ReflectorTW"
	copy $(ASM_BUILDDIR)\ReflectorTW\ReflectorTransition.prg $(ASM_LINKDIR)\ReflectorTW

$(ASM_BUILDDIR)\ReflectorTW\DISK-ReflectorTW.prg: $(ASM_PARTSDIR)\ReflectorTW\DISK-ReflectorTW.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\ReflectorTW\ReflectorTW.asm
	$(KICKASS) $(ASM_PARTSDIR)\ReflectorTW\DISK-ReflectorTW.asm -odir $(ASM_BUILDDIRRELPARTS)\ReflectorTW
	@if NOT EXIST "$(ASM_LINKDIR)\ReflectorTW" mkdir "$(ASM_LINKDIR)\ReflectorTW"
	copy $(ASM_BUILDDIR)\ReflectorTW\DISK-ReflectorTW.prg $(ASM_LINKDIR)\ReflectorTW
	


#RotatingGP --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\RotatingGP.d64: $(ASM_PARTSDIR)\RotatingGP\RotatingGP.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\RotatingGP\RotatingGP.prg $(ASM_BUILDDIR)\RotatingGP\FadeToNoBounds_RasterUpdateData.prg $(ASM_BUILDDIR)\RotatingGP\FadeToNoBounds.prg $(ASM_BUILDDIR)\RotatingGP\DISK-RotatingGP.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\RotatingGP\RotatingGP.sls

$(ASM_BUILDDIR)\RotatingGP\RotatingGP.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\RotatingGP\RotatingGP.asm $(ASM_BUILDDIR)\RotatingGP\MainIRQ.asm
	$(KICKASS) $(ASM_PARTSDIR)\RotatingGP\RotatingGP.asm -odir $(ASM_BUILDDIRRELPARTS)\RotatingGP
	@if NOT EXIST "$(ASM_LINKDIR)\RotatingGP" mkdir "$(ASM_LINKDIR)\RotatingGP"
	copy $(ASM_BUILDDIR)\RotatingGP\RotatingGP.prg $(ASM_LINKDIR)\RotatingGP

$(ASM_BUILDDIR)\RotatingGP\FadeToNoBounds_RasterUpdateData.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_BUILDDIR)\RotatingGP\FadeToNoBounds_RasterUpdateData.asm
	$(KICKASS) $(ASM_BUILDDIR)\RotatingGP\FadeToNoBounds_RasterUpdateData.asm
	@if NOT EXIST "$(ASM_LINKDIR)\RotatingGP" mkdir "$(ASM_LINKDIR)\RotatingGP"
	copy $(ASM_BUILDDIR)\RotatingGP\FadeToNoBounds_RasterUpdateData.prg $(ASM_LINKDIR)\RotatingGP

$(ASM_BUILDDIR)\RotatingGP\FadeToNoBounds.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\RotatingGP\FadeToNoBounds.asm
	$(KICKASS) $(ASM_PARTSDIR)\RotatingGP\FadeToNoBounds.asm -odir $(ASM_BUILDDIRRELPARTS)\RotatingGP
	@if NOT EXIST "$(ASM_LINKDIR)\RotatingGP" mkdir "$(ASM_LINKDIR)\RotatingGP"
	copy $(ASM_BUILDDIR)\RotatingGP\FadeToNoBounds.prg $(ASM_LINKDIR)\RotatingGP

$(ASM_BUILDDIR)\RotatingGP\DISK-RotatingGP.prg: $(ASM_PARTSDIR)\RotatingGP\DISK-RotatingGP.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\RotatingGP\RotatingGP.asm
	$(KICKASS) $(ASM_PARTSDIR)\RotatingGP\DISK-RotatingGP.asm -odir $(ASM_BUILDDIRRELPARTS)\RotatingGP
	@if NOT EXIST "$(ASM_LINKDIR)\RotatingGP" mkdir "$(ASM_LINKDIR)\RotatingGP"
	copy $(ASM_BUILDDIR)\RotatingGP\DISK-RotatingGP.prg $(ASM_LINKDIR)\RotatingGP



#SpriteFpp --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\SpriteFpp.d64: $(ASM_PARTSDIR)\SpriteFPP\SpriteFPP.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\SpriteFPP\SpriteFPP.prg $(ASM_BUILDDIR)\SpriteFPP\DISK-SpriteFPP.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\SpriteFPP\SpriteFPP.sls

$(ASM_BUILDDIR)\SpriteFPP\SpriteFPP.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\SpriteFPP\SpriteFPP.asm $(ASM_PARTSDIR)\SpriteFPP\functions.asm $(ASM_PARTSDIR)\SpriteFPP\actions.asm $(ASM_PARTSDIR)\SpriteFPP\fpp_irq.asm $(ASM_PARTSDIR)\SpriteFPP\scene_settings.asm $(ASM_PARTSDIR)\SpriteFPP\variables.asm
	$(KICKASS) $(ASM_PARTSDIR)\SpriteFPP\SpriteFPP.asm -odir $(ASM_BUILDDIRRELPARTS)\SpriteFPP
	@if NOT EXIST "$(ASM_LINKDIR)\SpriteFPP" mkdir "$(ASM_LINKDIR)\SpriteFPP"
	copy $(ASM_BUILDDIR)\SpriteFPP\SpriteFPP.prg $(ASM_LINKDIR)\SpriteFPP

$(ASM_BUILDDIR)\SpriteFPP\DISK-SpriteFPP.prg: $(ASM_PARTSDIR)\SpriteFPP\DISK-SpriteFPP.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\SpriteFPP\SpriteFPP.asm
	$(KICKASS) $(ASM_PARTSDIR)\SpriteFPP\DISK-SpriteFPP.asm -odir $(ASM_BUILDDIRRELPARTS)\SpriteFPP
	@if NOT EXIST "$(ASM_LINKDIR)\SpriteFPP" mkdir "$(ASM_LINKDIR)\SpriteFPP"
	copy $(ASM_BUILDDIR)\SpriteFPP\DISK-SpriteFpp.prg $(ASM_LINKDIR)\SpriteFPP



#StarWars --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\StarWars.d64: $(ASM_PARTSDIR)\StarWars\StarWars.sls $(ASM_BUILDDIR)\StarWars\StarWars.prg $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\StarWars\DISK-StarWars.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\StarWars\StarWars.sls

$(ASM_BUILDDIR)\StarWars\StarWars.prg: $(ASM_BUILDDIR)\StarWars\SW-Plot.asm $(ASM_BUILDDIR)\StarWars\SW-Uniques.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\StarWars\StarWars.asm
	$(KICKASS) $(ASM_PARTSDIR)\StarWars\StarWars.asm -odir $(ASM_BUILDDIRRELPARTS)\StarWars
	@if NOT EXIST "$(ASM_LINKDIR)\StarWars" mkdir "$(ASM_LINKDIR)\StarWars"
	copy $(ASM_BUILDDIR)\StarWars\StarWars.prg $(ASM_LINKDIR)\StarWars

$(ASM_BUILDDIR)\StarWars\DISK-StarWars.prg: $(ASM_PARTSDIR)\StarWars\DISK-StarWars.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\StarWars\StarWars.prg
	$(KICKASS) $(ASM_PARTSDIR)\StarWars\DISK-StarWars.asm -odir $(ASM_BUILDDIRRELPARTS)\StarWars
	@if NOT EXIST "$(ASM_LINKDIR)\StarWars" mkdir "$(ASM_LINKDIR)\StarWars"
	copy $(ASM_BUILDDIR)\StarWars\DISK-StarWars.prg $(ASM_LINKDIR)\StarWars

$(ASM_BUILDDIR)\StarWars\rastertrans.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\StarWars\rastertrans.asm
	$(KICKASS) $(ASM_PARTSDIR)\StarWars\rastertrans.asm -odir $(ASM_BUILDDIRRELPARTS)\StarWars
	@if NOT EXIST "$(ASM_LINKDIR)\StarWars" mkdir "$(ASM_LINKDIR)\StarWars"
	copy $(ASM_BUILDDIR)\StarWars\rastertrans.prg $(ASM_LINKDIR)\StarWars



#TechTech --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\TechTech.d64: $(ASM_PARTSDIR)\TechTech\TechTech.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\TechTech\TechTech.prg $(ASM_BUILDDIR)\TechTech\DISK-TechTech.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg $(ASM_BUILDDIR)\TransitionSquares\TransitionSquares.prg
	$(SPARKLE) $(ASM_PARTSDIR)\TechTech\TechTech.sls

$(ASM_BUILDDIR)\TechTech\TechTech.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\TechTech\TechTech.asm $(ASM_PARTSDIR)\TechTech\functions_tech_colour.asm $(ASM_PARTSDIR)\TechTech\functions_tech_intro.asm $(ASM_PARTSDIR)\TechTech\functions_tech.asm  $(ASM_PARTSDIR)\TechTech\scene_settings_tech.asm $(ASM_PARTSDIR)\TechTech\tech_irq_bankswitch.asm $(ASM_PARTSDIR)\TechTech\unrolled_code_generators.asm $(ASM_PARTSDIR)\TechTech\variables.asm
	$(KICKASS) $(ASM_PARTSDIR)\TechTech\TechTech.asm -odir $(ASM_BUILDDIRRELPARTS)\TechTech
	@if NOT EXIST "$(ASM_LINKDIR)\TechTech" mkdir "$(ASM_LINKDIR)\TechTech"
	copy $(ASM_BUILDDIR)\TechTech\TechTech.prg $(ASM_LINKDIR)\TechTech

$(ASM_BUILDDIR)\TechTech\DISK-TechTech.prg: $(ASM_PARTSDIR)\TechTech\DISK-TechTech.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\TechTech\TechTech.asm
	$(KICKASS) $(ASM_PARTSDIR)\TechTech\DISK-TechTech.asm -odir $(ASM_BUILDDIRRELPARTS)\TechTech
	@if NOT EXIST "$(ASM_LINKDIR)\TechTech" mkdir "$(ASM_LINKDIR)\TechTech"
	copy $(ASM_BUILDDIR)\TechTech\DISK-TechTech.prg $(ASM_LINKDIR)\TechTech



#TinyCircleScroll --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\TinyCircleScroll.d64: $(ASM_PARTSDIR)\TinyCircleScroll\TinyCircleScroll.sls $(ASM_BUILDDIR)\TinyCircleScroll\TinyCircleScroll.prg $(ASM_BUILDDIR)\TinyCircleScroll\TinyCircleScroll-DZX0.prg $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\TinyCircleScroll\DISK-TinyCircleScroll.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\TinyCircleScroll\TinyCircleScroll.sls

$(ASM_BUILDDIR)\TinyCircleScroll\TinyCircleScroll.prg: $(ASM_BUILDDIR)\TinyCircleScroll\PlotCode.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\TinyCircleScroll\TinyCircleScroll.asm $(ASM_BUILDDIR)\TinyCircleScroll\UpdatePlot.asm $(ASM_BUILDDIR)\TinyCircleScroll\PlotCode.asm
	$(KICKASS) $(ASM_PARTSDIR)\TinyCircleScroll\TinyCircleScroll.asm -odir $(ASM_BUILDDIRRELPARTS)\TinyCircleScroll
	$(DALI) $(ASM_BUILDDIR)\TinyCircleScroll\TinyCircleScroll.prg
	@if NOT EXIST "$(ASM_LINKDIR)\TinyCircleScroll" mkdir "$(ASM_LINKDIR)\TinyCircleScroll"
	copy $(ASM_BUILDDIR)\TinyCircleScroll\TinyCircleScroll.prg $(ASM_LINKDIR)\TinyCircleScroll
	copy $(ASM_BUILDDIR)\TinyCircleScroll\TinyCircleScroll.prg.lz $(ASM_LINKDIR)\TinyCircleScroll

$(ASM_BUILDDIR)\TinyCircleScroll\TinyCircleScroll-DZX0.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\TinyCircleScroll\TinyCircleScroll-DZX0.asm
	$(KICKASS) $(ASM_PARTSDIR)\TinyCircleScroll\TinyCircleScroll-DZX0.asm -odir $(ASM_BUILDDIRRELPARTS)\TinyCircleScroll
	@if NOT EXIST "$(ASM_LINKDIR)\TinyCircleScroll" mkdir "$(ASM_LINKDIR)\TinyCircleScroll"
	copy $(ASM_BUILDDIR)\TinyCircleScroll\TinyCircleScroll-DZX0.prg $(ASM_LINKDIR)\TinyCircleScroll

$(ASM_BUILDDIR)\TinyCircleScroll\DISK-TinyCircleScroll.prg: $(ASM_PARTSDIR)\TinyCircleScroll\DISK-TinyCircleScroll.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\TinyCircleScroll\TinyCircleScroll.prg
	$(KICKASS) $(ASM_PARTSDIR)\TinyCircleScroll\DISK-TinyCircleScroll.asm -odir $(ASM_BUILDDIRRELPARTS)\TinyCircleScroll
	@if NOT EXIST "$(ASM_LINKDIR)\TinyCircleScroll" mkdir "$(ASM_LINKDIR)\TinyCircleScroll"
	copy $(ASM_BUILDDIR)\TinyCircleScroll\DISK-TinyCircleScroll.prg $(ASM_LINKDIR)\TinyCircleScroll



#Trailblazer --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\Trailblazer.d64: $(ASM_PARTSDIR)\Trailblazer\Trailblazer.sls $(ASM_BUILDDIR)\Trailblazer\TrailblazerTransition.prg $(ASM_BUILDDIR)\Trailblazer\Trailblazer.prg $(ASM_PARTSDIR)\Trailblazer\Data\Checker00.bin $(ASM_PARTSDIR)\Trailblazer\Data\Checker01.bin $(ASM_PARTSDIR)\Trailblazer\Data\Checker02.bin $(ASM_PARTSDIR)\Trailblazer\Data\Checker03.bin $(ASM_LINKDIR)\Trailblazer\ColorData.bin $(ASM_PARTSDIR)\Trailblazer\Data\RowData.bin $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\Trailblazer\DISK-Trailblazer.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\Trailblazer\Trailblazer.sls
	
$(ASM_BUILDDIR)\Trailblazer\TrailblazerTransition.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\Trailblazer\TrailblazerTransition.asm
	$(KICKASS) $(ASM_PARTSDIR)\Trailblazer\TrailblazerTransition.asm -odir $(ASM_BUILDDIRRELPARTS)\Trailblazer
	@if NOT EXIST "$(ASM_LINKDIR)\Trailblazer" mkdir "$(ASM_LINKDIR)\Trailblazer"
	copy $(ASM_BUILDDIR)\Trailblazer\TrailblazerTransition.prg $(ASM_LINKDIR)\Trailblazer

$(ASM_BUILDDIR)\Trailblazer\Trailblazer.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\Trailblazer\Trailblazer.asm $(ASM_PARTSDIR)\Trailblazer\TrailblazerIntro.asm
	$(KICKASS) $(ASM_PARTSDIR)\Trailblazer\Trailblazer.asm -odir $(ASM_BUILDDIRRELPARTS)\Trailblazer
	@if NOT EXIST "$(ASM_LINKDIR)\Trailblazer" mkdir "$(ASM_LINKDIR)\Trailblazer"
	copy $(ASM_BUILDDIR)\Trailblazer\Trailblazer.prg $(ASM_LINKDIR)\Trailblazer

$(ASM_BUILDDIR)\Trailblazer\DISK-Trailblazer.prg: $(ASM_PARTSDIR)\Trailblazer\DISK-Trailblazer.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\Trailblazer\Trailblazer.prg
	$(KICKASS) $(ASM_PARTSDIR)\Trailblazer\DISK-Trailblazer.asm -odir $(ASM_BUILDDIRRELPARTS)\Trailblazer
	@if NOT EXIST "$(ASM_LINKDIR)\Trailblazer" mkdir "$(ASM_LINKDIR)\Trailblazer"
	copy $(ASM_BUILDDIR)\Trailblazer\DISK-Trailblazer.prg $(ASM_LINKDIR)\Trailblazer


#TransitionScattered --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\TransitionScattered.d64: $(ASM_PARTSDIR)\TransitionScattered\TransitionScattered.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\TransitionScattered\TransitionScattered.prg $(ASM_BUILDDIR)\TransitionScattered\DISK-TransitionScattered.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\TransitionScattered\TransitionScattered.sls

$(ASM_BUILDDIR)\TransitionScattered\TransitionScattered.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\TransitionScattered\TransitionScattered.asm $(ASM_PARTSDIR)\TransitionScattered\macros.asm $(ASM_PARTSDIR)\TransitionScattered\functions.asm $(ASM_PARTSDIR)\TransitionScattered\scene_settings.asm $(ASM_PARTSDIR)\TransitionScattered\variables.asm
	$(KICKASS) $(ASM_PARTSDIR)\TransitionScattered\TransitionScattered.asm -odir $(ASM_BUILDDIRRELPARTS)\TransitionScattered
	@if NOT EXIST "$(ASM_LINKDIR)\TransitionScattered" mkdir "$(ASM_LINKDIR)\TransitionScattered"
	copy $(ASM_BUILDDIR)\TransitionScattered\TransitionScattered.prg $(ASM_LINKDIR)\TransitionScattered

$(ASM_BUILDDIR)\TransitionScattered\DISK-TransitionScattered.prg: $(ASM_PARTSDIR)\TransitionScattered\DISK-TransitionScattered.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\TransitionScattered\TransitionScattered.asm
	$(KICKASS) $(ASM_PARTSDIR)\TransitionScattered\DISK-TransitionScattered.asm -odir $(ASM_BUILDDIRRELPARTS)\TransitionScattered
	@if NOT EXIST "$(ASM_LINKDIR)\TransitionScattered" mkdir "$(ASM_LINKDIR)\TransitionScattered"
	copy $(ASM_BUILDDIR)\TransitionScattered\DISK-TransitionScattered.prg $(ASM_LINKDIR)\TransitionScattered

	
#TransitionSquares --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\TransitionSquares.d64: $(ASM_PARTSDIR)\TransitionSquares\TransitionSquares.sls $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\TransitionSquares\TransitionSquares.prg $(ASM_BUILDDIR)\TransitionSquares\DISK-TransitionSquares.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\TransitionSquares\TransitionSquares.sls

$(ASM_BUILDDIR)\TransitionSquares\TransitionSquares.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\TransitionSquares\TransitionSquares.asm $(ASM_PARTSDIR)\TransitionSquares\functions.asm $(ASM_PARTSDIR)\TransitionSquares\scene_settings.asm $(ASM_PARTSDIR)\TransitionSquares\variables.asm
	$(KICKASS) $(ASM_PARTSDIR)\TransitionSquares\TransitionSquares.asm -odir $(ASM_BUILDDIRRELPARTS)\TransitionSquares
	@if NOT EXIST "$(ASM_LINKDIR)\TransitionSquares" mkdir "$(ASM_LINKDIR)\TransitionSquares"
	copy $(ASM_BUILDDIR)\TransitionSquares\TransitionSquares.prg $(ASM_LINKDIR)\TransitionSquares

$(ASM_BUILDDIR)\TransitionSquares\DISK-TransitionSquares.prg: $(ASM_PARTSDIR)\TransitionSquares\DISK-TransitionSquares.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_PARTSDIR)\TransitionSquares\TransitionSquares.asm
	$(KICKASS) $(ASM_PARTSDIR)\TransitionSquares\DISK-TransitionSquares.asm -odir $(ASM_BUILDDIRRELPARTS)\TransitionSquares
	@if NOT EXIST "$(ASM_LINKDIR)\TransitionSquares" mkdir "$(ASM_LINKDIR)\TransitionSquares"
	copy $(ASM_BUILDDIR)\TransitionSquares\DISK-TransitionSquares.prg $(ASM_LINKDIR)\TransitionSquares



#Tunnel --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\Tunnel.d64: $(ASM_PARTSDIR)\Tunnel\Tunnel.sls $(ASM_BUILDDIR)\Tunnel\Tunnel.prg $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\Tunnel\DISK-Tunnel.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\Tunnel\Tunnel.sls
	
$(ASM_BUILDDIR)\Tunnel\Tunnel.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\Tunnel\Tunnel.asm $(ASM_BUILDDIR)\Tunnel\MainIRQCode.asm
	$(KICKASS) $(ASM_PARTSDIR)\Tunnel\Tunnel.asm -odir $(ASM_BUILDDIRRELPARTS)\Tunnel
	@if NOT EXIST "$(ASM_LINKDIR)\Tunnel" mkdir "$(ASM_LINKDIR)\Tunnel"
	copy $(ASM_BUILDDIR)\Tunnel\Tunnel.prg $(ASM_LINKDIR)\Tunnel

$(ASM_BUILDDIR)\Tunnel\DISK-Tunnel.prg: $(ASM_PARTSDIR)\Tunnel\DISK-Tunnel.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\Tunnel\Tunnel.prg
	$(KICKASS) $(ASM_PARTSDIR)\Tunnel\DISK-Tunnel.asm -odir $(ASM_BUILDDIRRELPARTS)\Tunnel
	@if NOT EXIST "$(ASM_LINKDIR)\Tunnel" mkdir "$(ASM_LINKDIR)\Tunnel"
	copy $(ASM_BUILDDIR)\Tunnel\DISK-Tunnel.prg $(ASM_LINKDIR)\Tunnel



#TwistScroll --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\TwistScroll.d64: $(ASM_PARTSDIR)\TwistScroll\TwistScroll.sls $(ASM_BUILDDIR)\TwistScroll\TwistScroll.prg $(ASM_BUILDDIR)\TwistScroll\TwistScroll-DZX0.prg $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\TwistScroll\DISK-TwistScroll.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\TwistScroll\TwistScroll.sls

$(ASM_BUILDDIR)\TwistScroll\TwistScroll.prg: $(ASM_BUILDDIR)\TwistScroll\PlotCode.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\TwistScroll\TwistScroll.asm
	$(KICKASS) $(ASM_PARTSDIR)\TwistScroll\TwistScroll.asm -odir $(ASM_BUILDDIRRELPARTS)\TwistScroll
	$(DALI) $(ASM_BUILDDIR)\TwistScroll\TwistScroll.prg
	@if NOT EXIST "$(ASM_LINKDIR)\TwistScroll" mkdir "$(ASM_LINKDIR)\TwistScroll"
	copy $(ASM_BUILDDIR)\TwistScroll\TwistScroll.prg $(ASM_LINKDIR)\TwistScroll
	copy $(ASM_BUILDDIR)\TwistScroll\TwistScroll.prg.lz $(ASM_LINKDIR)\TwistScroll

$(ASM_BUILDDIR)\TwistScroll\TwistScroll-DZX0.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\TwistScroll\TwistScroll-DZX0.asm
	$(KICKASS) $(ASM_PARTSDIR)\TwistScroll\TwistScroll-DZX0.asm -odir $(ASM_BUILDDIRRELPARTS)\TwistScroll
	@if NOT EXIST "$(ASM_LINKDIR)\TwistScroll" mkdir "$(ASM_LINKDIR)\TwistScroll"
	copy $(ASM_BUILDDIR)\TwistScroll\TwistScroll-DZX0.prg $(ASM_LINKDIR)\TwistScroll

$(ASM_BUILDDIR)\TwistScroll\DISK-TwistScroll.prg: $(ASM_PARTSDIR)\TwistScroll\DISK-TwistScroll.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\TwistScroll\TwistScroll.prg
	$(KICKASS) $(ASM_PARTSDIR)\TwistScroll\DISK-TwistScroll.asm -odir $(ASM_BUILDDIRRELPARTS)\TwistScroll
	@if NOT EXIST "$(ASM_LINKDIR)\TwistScroll" mkdir "$(ASM_LINKDIR)\TwistScroll"
	copy $(ASM_BUILDDIR)\TwistScroll\DISK-TwistScroll.prg $(ASM_LINKDIR)\TwistScroll



#VerticalBitmapScroll --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
D64\VerticalBitmapScroll.d64: $(ASM_PARTSDIR)\VerticalBitmapScroll\VerticalBitmapScroll.sls $(ASM_LINKDIR)\VerticalBitmapScroll\StreamData.sls $(ASM_LINKDIR)\VerticalBitmapScroll\StreamData.bin $(ASM_LINKDIR)\VerticalBitmapScroll\Redcrab-Credits.map $(ASM_BUILDDIR)\VerticalBitmapScroll\VerticalBitmapScroll.prg $(ASM_BUILDDIR)\Main\Entry.prg $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\VerticalBitmapScroll\DISK-VerticalBitmapScroll.prg $(ASM_BUILDDIR)\Main\DISK-EndOfDisk.prg
	$(SPARKLE) $(ASM_PARTSDIR)\VerticalBitmapScroll\VerticalBitmapScroll.sls

$(ASM_BUILDDIR)\VerticalBitmapScroll\VerticalBitmapScroll.prg: $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_MAINDIR)\Main-BaseCode.asm $(ASM_PARTSDIR)\VerticalBitmapScroll\VerticalBitmapScroll.asm $(ASM_BUILDDIR)\VerticalBitmapScroll\VerticalBitmapScroll-ChunkLoadDefine.sym
	$(KICKASS) $(ASM_PARTSDIR)\VerticalBitmapScroll\VerticalBitmapScroll.asm -odir $(ASM_BUILDDIRRELPARTS)\VerticalBitmapScroll
	@if NOT EXIST "$(ASM_LINKDIR)\VerticalBitmapScroll" mkdir "$(ASM_LINKDIR)\VerticalBitmapScroll"
	copy $(ASM_BUILDDIR)\VerticalBitmapScroll\VerticalBitmapScroll.prg $(ASM_LINKDIR)\VerticalBitmapScroll

$(ASM_BUILDDIR)\VerticalBitmapScroll\DISK-VerticalBitmapScroll.prg: $(ASM_PARTSDIR)\VerticalBitmapScroll\DISK-VerticalBitmapScroll.asm $(ASM_MAINDIR)\Main-CommonDefines.asm $(ASM_MAINDIR)\Main-CommonMacros.asm $(ASM_BUILDDIR)\Main\Main-BaseCode.prg $(ASM_BUILDDIR)\VerticalBitmapScroll\VerticalBitmapScroll.prg $(ASM_BUILDDIR)\VerticalBitmapScroll\VerticalBitmapScroll-ChunkLoadDefine.sym
	$(KICKASS) $(ASM_PARTSDIR)\VerticalBitmapScroll\DISK-VerticalBitmapScroll.asm -odir $(ASM_BUILDDIRRELPARTS)\VerticalBitmapScroll
	@if NOT EXIST "$(ASM_LINKDIR)\VerticalBitmapScroll" mkdir "$(ASM_LINKDIR)\VerticalBitmapScroll"
	copy $(ASM_BUILDDIR)\VerticalBitmapScroll\DISK-VerticalBitmapScroll.prg $(ASM_LINKDIR)\VerticalBitmapScroll



