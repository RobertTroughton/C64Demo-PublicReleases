#Entry
File:		..\..\Link\MAIN\EntryWithKefrens.prg

#Base code
File:		..\..\Link\MAIN\Main-BaseCode.prg

#SID to $f000
File:		..\..\Music\Acrouzet-Golden-F000.sid

#Kefrens
File:		..\..\Link\KefrensPlus\DISK-KefrensPlus.prg
File:		..\..\Link\KefrensPlus\KefrensPlusFadeIn.prg										2600	0002	0300
File:		..\..\Link\KefrensPlus\KefrensPlusFadeIn.prg										4000	1a02
File:		..\..\Parts\KefrensPlus\Data\KefrensSprites.bin										3c00	0000	0080
File:		..\..\Parts\KefrensPlus\Data\KefrensSprites.bin										3d00	0080	0080
File:		..\..\Parts\KefrensPlus\Data\KefrensSprites.bin										3e00	0100	0080
File:		..\..\Parts\KefrensPlus\Data\KefrensSprites.bin										3f00	0180	0080
File:		..\..\Parts\KefrensPlus\Data\BordersForBooze.map									2100	0000	0080
File:		..\..\Parts\KefrensPlus\Data\BordersForBooze.map									2200	0080	0080
File:		..\..\Parts\KefrensPlus\Data\BordersForBooze.map									2300	0100	0080
File:		..\..\Parts\KefrensPlus\Data\LowBarsByCrest.map										2a00	0000	0080
File:		..\..\Parts\KefrensPlus\Data\LowBarsByCrest.map										2b00	0080	0080
File:		..\..\Parts\KefrensPlus\Data\LowBarsByCrest.map										2c00	0100	0080
File:		..\..\Parts\KefrensPlus\Data\NoBoundsForGP.map										2d00	0000	0080
File:		..\..\Parts\KefrensPlus\Data\NoBoundsForGP.map										2e00	0080	0080
File:		..\..\Parts\KefrensPlus\Data\NoBoundsForGP.map										2f00	0100	0080
File:		..\..\Parts\KefrensPlus\Data\RaisingTheBarsChars.bin								3000
File:		..\..\Parts\KefrensPlus\Data\RaisingTheBarsScreen.bin								35b8

File:		..\..\Link\KefrensPlus\KefrensPlus.prg*

#SID to $0900
Mem:		..\..\Music\Acrouzet-Golden-F000.sid												f000	007e
File:		..\..\Music\Acrouzet-Golden.sid
File:		..\..\Link\FFData.bin																08ff	0000	0001

#Transition Scattered
File:		..\..\Link\TwistScroll\DISK-TwistScroll.prg
File:		..\..\Link\TransitionScattered\TransitionScattered.prg

#Twist Scroll
File:		..\..\Link\TwistScroll\TwistScroll-DZX0.prg
File:		..\..\Link\TwistScroll\TwistScroll.prg.lz
File:		..\..\Link\TwistScroll\TwistScroll.prg.lz											00f1	0000	0004
File:		..\..\Link\TwistScroll\ScrollText.bin												b000
File:		..\..\Link\TwistScroll\CharSets.bin*												d800	0000	27f8
File:		..\..\Link\TwistScroll\BKG.map*														c400
File:		..\..\Link\TwistScroll\YSine.bin													bf00

#Preloading CheckerZoomer.prg
File:		..\..\Link\CheckerZoomer\CheckerZoomer.prg											8800	0002	02c1
File:		..\..\Link\CheckerZoomer\CheckerZoomer.prg											8b00	7902	1100
File:		..\..\Link\CheckerZoomer\CheckerZoomer.prg											9c00	a002	0100
File:		..\..\Link\CheckerZoomer\CheckerZoomer.prg											9d00	a402

#Chessboard Zoomer
File:		..\..\Link\CheckerZoomer\DISK-CheckerZoomer.prg

Mem:		..\..\Link\CheckerZoomer\CheckerZoomer.prg											0400	0002	02c1
Mem:		..\..\Link\CheckerZoomer\CheckerZoomer.prg											7d00	7902	1100
Mem:		..\..\Link\CheckerZoomer\CheckerZoomer.prg											a400	a002	0100
Mem:		..\..\Link\CheckerZoomer\CheckerZoomer.prg											a800	a402
File:		..\..\Link\CheckerZoomer\PhaseTables.bin											ac00
File:		..\..\Link\CheckerZoomer\DeltaTables.bin											ad00
File:		..\..\Link\CheckerZoomer\OffsetTable.bin											ad40
File:		..\..\Link\CheckerZoomer\SpriteData.bin												9000
File:		..\..\Link\CheckerZoomer\PointerData.bin											9400

#Chessboard bitmap and sprites #1
File:		..\..\Link\CheckerZoomer\Chessboard.col												d800
File:		..\..\Link\CheckerZoomer\Chessboard.scr												e000
File:		..\..\Link\CheckerZoomer\Chessboard.map*											dc00	1c00
File:		..\..\Link\CheckerZoomer\Chessboard.map*											df40	03f8	0008
File:		..\..\Link\CheckerZoomer\Chessboard.map*											df48	07f8	0008
File:		..\..\Link\CheckerZoomer\Chessboard.map*											df50	0bf8	0008
File:		..\..\Link\CheckerZoomer\Chessboard.map*											df58	0ff8	0008
File:		..\..\Link\CheckerZoomer\Chessboard.map*											df60	13f8	0008
File:		..\..\Link\CheckerZoomer\Chessboard.map*											df68	17f8	0008
File:		..\..\Link\CheckerZoomer\Chessboard.map*											df70	1bf8	0008
File:		..\..\Parts\CheckerZoomer\Data\ChessPiecesMC.bin									e400

#Chessboard bitmap and sprites #2
Mem:		..\..\Link\CheckerZoomer\Chessboard.col												d800
Mem:		..\..\Link\CheckerZoomer\Chessboard.scr												e000
Mem:		..\..\Link\CheckerZoomer\Chessboard.map*											dc00	1c00
Mem:		..\..\Link\CheckerZoomer\Chessboard.map*											df40	03f8	0008
Mem:		..\..\Link\CheckerZoomer\Chessboard.map*											df48	07f8	0008
Mem:		..\..\Link\CheckerZoomer\Chessboard.map*											df50	0bf8	0008
Mem:		..\..\Link\CheckerZoomer\Chessboard.map*											df58	0ff8	0008
Mem:		..\..\Link\CheckerZoomer\Chessboard.map*											df60	13f8	0008
Mem:		..\..\Link\CheckerZoomer\Chessboard.map*											df68	17f8	0008
Mem:		..\..\Link\CheckerZoomer\Chessboard.map*											df70	1bf8	0008
Mem:		..\..\Parts\CheckerZoomer\Data\ChessPiecesMC.bin									e400
File:		..\..\Link\CheckerZoomer\Chessboard.map												c000	0000	03f8
File:		..\..\Link\CheckerZoomer\Chessboard.map												c400	0400	03f8
File:		..\..\Link\CheckerZoomer\Chessboard.map												c800	0800	03f8
File:		..\..\Link\CheckerZoomer\Chessboard.map												cc00	0c00	03f8
File:		..\..\Link\CheckerZoomer\Chessboard.map*											d000	1000	03f8
File:		..\..\Link\CheckerZoomer\Chessboard.map*											d400	1400	03f8
File:		..\..\Link\CheckerZoomer\Chessboard.map*											d800	1800	03f8

#Preloading PlotCubeIntro
File:		..\..\Link\PlotCube\PlotCubeIntro.prg												e600	0002	01f8
File:		..\..\Link\PlotCube\PlotCubeIntro.prg												e800	0202	03f8
File:		..\..\Link\PlotCube\PlotCubeIntro.prg												ec00	0602

#PlotCube
File:		..\..\Link\PlotCube\DISK-PlotCube.prg
File:		..\..\Link\PlotCube\PlotCubeIntro.prg												ebf8	05fa	0008

File:		..\..\Link\PlotCube\RedcrabPodium00.map												5400
File:		..\..\Parts\PlotCube\Data\Plinth1Sprites.map										7400
File:		..\..\Parts\PlotCube\Data\Plinth2Sprites.map										7a00
File:		..\..\Parts\PlotCube\Data\Plinth3Sprites.map										7d00
File:		..\..\Link\PlotCube\RedcrabPodium0.col												8118
File:		..\..\Link\PlotCube\RedcrabPodium0.scr												8280
File:		..\..\Link\PlotCube\RedcrabPodium0.map												8400
File:		..\..\Link\PlotCube\PlotCube.prg
File:		..\..\Link\PlotCube\RedcrabPodium3.col												f118
File:		..\..\Link\PlotCube\RedcrabPodium3.scr												f280
File:		..\..\Link\PlotCube\RedcrabPodium3.map												f400

Mem:		..\..\Link\PlotCube\RedcrabPodium0.col												8118
Mem:		..\..\Link\PlotCube\RedcrabPodium0.scr												8280
Mem:		..\..\Link\PlotCube\RedcrabPodium0.map												8400
Mem:		..\..\Link\PlotCube\RedcrabPodium3.col												f118
Mem:		..\..\Link\PlotCube\RedcrabPodium3.scr												f280
Mem:		..\..\Link\PlotCube\RedcrabPodium3.map												f400
File:		..\..\Link\PlotCube\RedcrabPodium2.col												7118
File:		..\..\Link\PlotCube\RedcrabPodium2.scr												7280
File:		..\..\Link\PlotCube\RedcrabPodium2.map*												d000

Mem:		..\..\Link\PlotCube\RedcrabPodium0.col												8118
Mem:		..\..\Link\PlotCube\RedcrabPodium0.scr												8280
Mem:		..\..\Link\PlotCube\RedcrabPodium0.map												8400
Mem:		..\..\Link\PlotCube\RedcrabPodium3.col												f118
Mem:		..\..\Link\PlotCube\RedcrabPodium3.scr												f280
Mem:		..\..\Link\PlotCube\RedcrabPodium3.map												f400
Mem:		..\..\Link\PlotCube\RedcrabPodium2.col												7118
Mem:		..\..\Link\PlotCube\RedcrabPodium2.scr												7280
Mem:		..\..\Link\PlotCube\RedcrabPodium2.map*												d000
File:		..\..\Link\PlotCube\RedcrabPodium1.scr												3280
File:		..\..\Link\PlotCube\RedcrabPodium1.map												3400
File:		..\..\Link\PlotCube\RedcrabPodium1.col												4e98
File:		..\..\Parts\PlotCube\Data\ColFadeToWhite.bin										ff40

#Transition Squares
File:		..\..\Link\TransitionSquares\TransitionSquares.prg									2000	0002

#TechTech DISK code
File:		..\..\Link\TechTech\DISK-TechTech.prg

#TechTech
File:		..\..\Link\TechTech\TechTech.prg													2000	0002	2800
File:		..\..\Link\TechTech\TechTech.prg													9000	7002	07a0
File:		..\..\Link\TechTech\TechTech.prg													e000	c002

#CheckerBoard
File:		..\..\Link\CheckerBoard\DISK-CheckerBoard.prg
File:		..\..\Link\CheckerBoard\CheckerBoard.prg
File:		..\..\Link\CheckerBoard\ShiftedData.bin												8000
File:		..\..\Parts\CheckerBoard\Data\RandomC2.bin											bc00
File:		..\..\Parts\CheckerBoard\Data\LogoSpritesNoBounds.map								7600
File:		..\..\Parts\CheckerBoard\Data\LogoSpritesProject.map								7800
File:		..\..\Parts\CheckerBoard\Data\LogoSpritesGenesis.map								7a00

#BigDXYCP-StartScreen
File:		..\..\Link\BigDXYCP\DISK-BigDXYCP.prg
File:		..\..\Link\BigDXYCP\BigDXYCP.prg													2000	0002	0500
File:		..\..\Parts\BigDXYCP\Data\StartScreenChars.imap*									d000
File:		..\..\Parts\BigDXYCP\Data\StartScreenChars.iscr*									d490
File:		..\..\Parts\BigDXYCP\Data\facet-302Bobs.map											8b80

#BigDXYCP
Mem:		..\..\Link\BigDXYCP\BigDXYCP.prg													2000	0002	0500
File:		..\..\Link\BigDXYCP\BigDXYCP-DZX0.prg
File:		..\..\Link\BigDXYCP\BigDXYCP.prg.lz
File:		..\..\Link\BigDXYCP\BigDXYCP.prg.lz													00f1	0000	0004
File:		..\..\Link\BigDXYCP\FontData.bin													9000
File:		..\..\Link\BigDXYCP\Bitmap.map														a000
File:		..\..\Link\BigDXYCP\Bitmap.scr														0400
File:		..\..\Link\BigDXYCP\Scrolltext.bin													9800

#Earth Bitmap Fade-in
File:		..\..\Link\Earth\DISK-Earth.prg
File:		..\..\Link\Earth\Earth.prg															e800	0002	0530
File:		..\..\Link\Earth\FacetSun.map*														c000
File:		..\..\Link\Earth\FacetSun.scr														e400
File:		..\..\Link\Earth\FacetSun.col														bc00

#Earth
Mem:		..\..\Link\Earth\Earth.prg															e800	0002	0530
Mem:		..\..\Link\Earth\FacetSun.map*														c000
Mem:		..\..\Link\Earth\FacetSun.scr														e400
Mem:		..\..\Link\Earth\FacetSun.col														bc00
File:		..\..\Link\Earth\Earth.prg															f100	0902
File:		..\..\Link\Earth\SineTable.bin														0400
File:		..\..\Link\Earth\Offsets.bin														3000
File:		..\..\Link\Earth\ByteCnt.bin														3d00
File:		..\..\Link\Earth\SpriteInterleave.bin												3e00
File:		..\..\Link\Earth\Map.bin															5fc0
File:		..\..\Link\Earth\BlueGlobeSprites.bin												ee00

#TARDIS - leading into Colour Cycle!
File:		..\..\Link\ColourCycle\DISK-ColourCycle.prg
File:		..\..\Link\ColourCycle\Tardis.prg
File:		..\..\Link\ColourCycle\Scrap-TardisSpritesMC.map									4400
File:		..\..\Parts\ColourCycle\Data\Scrap-60Years.map										4600
File:		..\..\Link\ColourCycle\SpriteSinus.bin												3d80

#Colour Cycle
#Mem:		..\..\Link\ColourCycle\Scrap-TardisSpritesMC.map									4400
#Mem:		..\..\Parts\ColourCycle\Data\Scrap-60Years.map										4600
#Mem:		..\..\Link\ColourCycle\SpriteSinus.bin												3d80
File:		..\..\Link\ColourCycle\DISK-ColourCycle.prg
File:		..\..\Link\ColourCycle\ColourCycle.prg
File:		..\..\Link\ColourCycle\CC0A.prg														4b00	0002
File:		..\..\Link\ColourCycle\CC0B.prg														2000	0002
File:		..\..\Link\ColourCycle\CC0.map														6000
File:		..\..\Link\ColourCycle\CC1A.prg														8b00	0002
File:		..\..\Link\ColourCycle\CC1.map														a000
File:		..\..\Link\ColourCycle\CC2A.prg														ea00	0002
File:		..\..\Link\ColourCycle\CC2.map*														c000
File:		..\..\Link\ColourCycle\SinTables.bin												3e00

Mem:		..\..\Link\ColourCycle\CC1A.prg														8b00	0002
File:		..\..\Link\ColourCycle\CC1B.prg														2000	0002

Mem:		..\..\Link\ColourCycle\CC2A.prg														ea00	0002
File:		..\..\Link\ColourCycle\CC2B.prg														2000	0002

#Infinite Bobs - Preload
File:		..\..\Link\InfiniteBobs\InfiniteBobs.prg
File:		..\..\Link\InfiniteBobs\SinTables.bin												b800
File:		..\..\Link\InfiniteBobs\ImageData.bin												8000

#Infinite Bobs
File:		..\..\Link\InfiniteBobs\DISK-InfiniteBobs.prg

File:		..\..\Link\InfiniteBobs\InfiniteBobs-FinalRasterFade.prg

#Vertical Bitmap Scroll
File:		..\..\Link\VerticalBitmapScroll\DISK-VerticalBitmapScroll.prg
File:		..\..\Link\VerticalBitmapScroll\VerticalBitmapScroll.prg
File:		..\..\Link\VerticalBitmapScroll\Redcrab-Credits.map									e000	0000	1f00
File:		..\..\Link\VerticalBitmapScroll\Redcrab-Credits.map									9000	1f00

Script:		..\..\Link\VerticalBitmapScroll\StreamData.sls
